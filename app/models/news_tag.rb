class NewsTag < ApplicationRecord
  belongs_to :scraped_news
  belongs_to :tag

  validates :scraped_news_id, uniqueness: {scope: :tag_id}
end
