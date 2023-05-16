desc "Update cron jobs based on enabled sources"
task update_all_jobs: :environment do
  Source.update_all_jobs
end
