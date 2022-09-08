class ScrapeSource < ApplicationJob
  queue_as :default

  def perform(source_name, tag_group)
    source = Source.where(name: source_name).first
    url = source.url

    links = Scraper.crawl(url)
    news = Parser.parse(url, links, tag_group)
    status = Writer.write(source.slug, news, tag_group)
  end
end
