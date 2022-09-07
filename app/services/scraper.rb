# scraper.rb
require 'nokogiri'
require 'open-uri'

class Scraper

  def self.crawl(url)
    # Fetch and parse HTML document
    doc = Nokogiri::HTML(URI.open(url))

    links = []
    # To list all anchor tags, do:
    doc.search('a').each{ |x| links << x }

    links
  end
end