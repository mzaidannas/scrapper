class NewsSource < ApplicationRecord
  belongs_to :scraped_news
  belongs_to :source

  validates :scraped_news_id, uniqueness: {scope: :source_id}
end
