require "puma/plugin"

Puma::Plugin.create do
  attr_reader :puma_pid, :sidekiq_pid, :log_writer, :sidekiq_embedded

  def start(launcher)
    @log_writer = launcher.log_writer
    @puma_pid = $$

    configure_sidekiq

    launcher.events.on_booted do
      start_sidekiq_process
    end

    launcher.events.on_stopped { stop_sidekiq }
    launcher.events.on_restart { stop_sidekiq }
  end

  private

  def configure_sidekiq
    @sidekiq_embedded = Sidekiq.configure_embed do |config|
      sidekiq_config = YAML.load_file(Rails.root.join('config', 'sidekiq.yml'))
      env_config = sidekiq_config[Rails.env] || {}

      config.concurrency = env_config['concurrency'] || sidekiq_config['concurrency'] || 10
      config.queues = env_config['queues'] || sidekiq_config['queues']

      if sidekiq_config['limits']
        sidekiq_config['limits'].each do |queue, limit|
          config.queue_limit queue => limit
        end
      end
    end
  end

  def start_sidekiq_process
    @sidekiq_pid = fork do
      begin
        Process.setproctitle("sidekiq #{Sidekiq::VERSION} scrapper [embedded]")
        log "Starting embedded Sidekiq process..."
        sidekiq_embedded.run
      rescue => e
        log "Error starting Sidekiq: #{e.message}"
        log e.backtrace.join("\n")
        exit(1)
      end
    end

    # Wait briefly to ensure Sidekiq starts properly
    sleep 2

    if sidekiq_started? && !sidekiq_dead?
      log "Sidekiq started successfully with PID #{sidekiq_pid}"
      in_background { monitor_sidekiq }
    else
      log "Failed to start Sidekiq process"
      stop_sidekiq
      raise "Failed to start Sidekiq process"
    end
  end

  def stop_sidekiq
    return unless sidekiq_started?
    begin
      log "Stopping Sidekiq..."
      Process.kill(:TERM, sidekiq_pid)
      Process.wait(sidekiq_pid)
    rescue Errno::ECHILD, Errno::ESRCH
      # Process already gone
    end
  end

  def monitor_puma
    monitor(:puma_dead?, "Detected Puma has gone away, stopping Sidekiq...")
  end

  def monitor_sidekiq
    monitor(:sidekiq_dead?, "Detected Sidekiq has gone away, stopping Puma...")
  end

  def monitor(process_dead, message)
    retries = 0
    loop do
      begin
        if send(process_dead) && retries >= 3
          log message
          Process.kill(:INT, $$)
          break
        end
        sleep 5  # Increased from 2 to 5 seconds
        retries += 1 if send(process_dead)
        retries = 0 if !send(process_dead) && retries > 0
      rescue StandardError => e
        log "Error monitoring process: #{e.message}"
        sleep 5
      end
    end
  end

  def sidekiq_dead?
    return false unless sidekiq_started?
    begin
      Process.kill(0, sidekiq_pid)
      false
    rescue Errno::ESRCH
      true
    end
  end

  def sidekiq_started?
    !sidekiq_pid.nil?
  end

  def puma_dead?
    Process.ppid != puma_pid
  end

  def log(msg)
    log_writer.log(msg)
  end
end
