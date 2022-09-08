class Source < ApplicationRecord
    validates :name, :slug, presence: true
    validates :slug, uniqueness: true
    
    belongs_to :tag_group

    has_many :news_sources
    has_many :scraped_news, through: :news_sources
end
