class Tag < ApplicationRecord
    validates :name, :slug, presence: true
    validates :slug, uniqueness: true

    has_many :news_tags
    has_many :scraped_news, through: :news_tags

    belongs_to :tag_group
end
