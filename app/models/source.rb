class Source < ApplicationRecord
  enum :schedule, {hourly: 'hourly', daily: 'daily', weekly: 'weekly', monthly: 'monthly', yearly: 'yearly'}

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  belongs_to :tag

  has_many :news_sources
  has_many :scraped_news, through: :news_sources

  after_commit :update_cron_job

  def tag_names
    tag.present? ? [tag.name] : []
  end

  def tag_names=(tag_names)
    self.tag = Tag.find_by(name: tag_names.first)
  end

  def update_cron_job
    if persisted?
      Sidekiq::Cron::Job.create(name: name, class: ScrapeSourceJob, cron: "@#{schedule}", args: [name, tag.name], status: enabled ? 'enabled' : 'disabled')
    else
      Sidekiq::Cron::Job.destroy(name)
    end
  end

  def self.update_all_jobs
    Source.includes(:tag).find_each do |source|
      Sidekiq::Cron::Job.create(
        name: source.name,
        class: ScrapeSourceJob,
        cron: "@#{source.schedule}",
        args: [source.name, source.tag.name],
        status: source.enabled ? 'enabled' : 'disabled'
      )
    end
  end
end
