class ScrapedNews < ApplicationRecord
  validates :datetime, :link, :slug, presence: true
  validates :slug, uniqueness: true

  has_many :news_tags
  has_many :tags, through: :news_tags

  has_many :news_sources
  has_many :sources, through: :news_sources

  accepts_nested_attributes_for :news_tags
  accepts_nested_attributes_for :news_sources

  def tag_names=(tag_names)
    self.tags = Tag.where(name: tag_names)
  end

  def tag_names
    tags.pluck(:name)
  end
end
