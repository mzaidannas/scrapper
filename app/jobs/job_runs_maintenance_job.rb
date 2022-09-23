class JobRunsMaintenanceJob
  include Sidekiq::Job
  queue_as :default

  def perform
    JobRun.maintenance
  end
end
