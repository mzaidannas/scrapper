class ScrapeSourceJob
  prepend ApplicationJob
  queue_as :default

  def perform(source_name, tag_name)
    source = Source.find_by(name: source_name)
    url = source.url

    links = Scraper.crawl(url)
    news = Parser.parse(url, links, tag_name)
    status = Writer.write(source.slug, news, tag_name)
    nil
  end
end
