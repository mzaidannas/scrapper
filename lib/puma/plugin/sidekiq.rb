require "puma/plugin"

Puma::Plugin.create do
  attr_reader :puma_pid, :sidekiq_pid, :log_writer, :sidekiq_embedded

  def start(launcher)
    @log_writer = launcher.log_writer
    @puma_pid = $$
    @sidekiq_embedded = Sidekiq.configure_embed do |config|
      # config.logger.level = Logger::DEBUG
      config.queues = %w[critical default low]
      config.concurrency = 2
    end

    in_background do
      monitor_sidekiq
    end

    launcher.events.on_booted do
      @sidekiq_pid = fork do
        Thread.new { monitor_puma }
        sidekiq_embedded.run
      end
    end

    launcher.events.on_stopped { stop_sidekiq }
    launcher.events.on_restart { stop_sidekiq }
  end

  private

  def stop_sidekiq
    Process.waitpid(sidekiq_pid, Process::WNOHANG)
    log "Stopping Sidekiq..."
    Process.kill(:INT, sidekiq_pid) if sidekiq_pid
    Process.wait(sidekiq_pid)
  rescue Errno::ECHILD, Errno::ESRCH
  end

  def monitor_puma
    monitor(:puma_dead?, "Detected Puma has gone away, stopping Sidekiq...")
  end

  def monitor_sidekiq
    monitor(:sidekiq_dead?, "Detected Sidekiq has gone away, stopping Puma...")
  end

  def monitor(process_dead, message)
    loop do
      if send(process_dead)
        log message
        Process.kill(:INT, $$)
        break
      end
      sleep 2
    end
  end

  def sidekiq_dead?
    if sidekiq_started?
      Process.waitpid(sidekiq_pid, Process::WNOHANG)
    end
    false
  rescue Errno::ECHILD, Errno::ESRCH
    true
  end

  def sidekiq_started?
    sidekiq_pid.present?
  end

  def puma_dead?
    Process.ppid != puma_pid
  end

  def log(...)
    log_writer.log(...)
  end
end
