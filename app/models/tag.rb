class Tag < ApplicationRecord
  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  has_many :news_tags
  has_many :scraped_news, through: :news_tags
  has_many :sources

  include HierarchicalModel
end
