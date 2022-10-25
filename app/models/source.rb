class Source < ApplicationRecord
  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  belongs_to :tag

  has_many :news_sources
  has_many :scraped_news, through: :news_sources

  def tag_name=(tag_names)
    self.tag = Tag.find_by(name: tag_names.first)
  end

  def tag_names
    tag.present? ? [tag.name] : []
  end

  def tag_names=(tag_names)
    self.tag = Tag.find_by(name: tag_names.first)
  end
end
