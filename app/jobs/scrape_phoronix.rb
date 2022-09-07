class ScrapePhoronix < ApplicationJob
  queue_as :default

  def perform(*args)
    urls = ['https://www.phoronix.com']
    news = []

    urls.each do |url|
      links = Scraper.crawl(url)
      news.push(Parser.parse(url,links))
    end
    news.flatten
  end
end
