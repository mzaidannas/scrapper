desc "Update cron jobs based on enabled sources"
task :update_all_jobs do
  Source.update_all_jobs
end
