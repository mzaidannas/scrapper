Sidekiq::Job.extend ActiveSupport::Concern

module ApplicationJob
  extend ActiveSupport::Concern

  prepended do
    include Sidekiq::Job
  end

  def perform(*args)
    job_name = self.class.name.underscore.delete_suffix!('_job').freeze
    job_run = JobRun.create!(name: job_name)
    warnings = super
    record_job_run(job_run, warnings)
    true
  rescue => e
    Rails.logger.debug e.full_message
    job_run.update(status: :error, error_message: e.message, error_detail: e.full_message)
  end

  private

  def record_job_run(job_run, msg = '')
    params = {status: msg.blank? ? :success : :warning, completed_at: Time.current, error_message: msg}.compact_blank!
    job_run.update(params)
  end
end
