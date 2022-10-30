schedule_file = 'config/schedule.yml'.freeze

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
end

Sidekiq.configure_server do |config|
  config.redis = {url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')}
end
