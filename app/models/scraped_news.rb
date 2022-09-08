class ScrapedNews < ApplicationRecord
    validates :datetime, :link, :slug, presence: true
    validates :slug, uniqueness: true

    has_many :news_tags
    has_many :tags, through: :news_tags

    has_many :news_sources
    has_many :sources, through: :news_sources
end
