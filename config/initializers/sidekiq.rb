Sidekiq.configure_server do |config|
  #config.redis = { url: 'redis://localhost:6379/0'  }
  schedule_file = "config/schedule.yml"
  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.options[:poll_interval] = 5
