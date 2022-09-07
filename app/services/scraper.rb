# scraper.rb
require 'nokogiri'

class Scraper

  def crawl
    # Fetch and parse HTML document
    doc = Nokogiri::HTML(URI.open("https://www.phoronix.com/"))

    links = []
    # To list all anchor tags, do:
    doc.search('a').each{ |x| links << x }

    links
  end
end