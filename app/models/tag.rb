class Tag < ApplicationRecord
  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  has_many :news_tags
  has_many :scraped_news, through: :news_tags
  has_many :sources

  include HierarchicalModel

  scope :valid_tags, -> { where(to_ignore: false, enabled: true) }
  scope :ignored_tags, -> { where(to_ignore: true, enabled: true) }
end
