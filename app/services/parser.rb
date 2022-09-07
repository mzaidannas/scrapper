# parser.rb

class Parser

  def self.parse(url, links, type = 'Software')
    news = []
    date = DateTime.current
    tags = TagGroup.where(name: type).first.tags.pluck(:name)

    links.each do |link|
      news_tags = []
      news_link = link['href'].downcase
      news_headline = link.children.text
      tags.each do |tag|
        if (news_link && news_link.include?(tag.downcase)) ||
          (news_headline && news_headline.downcase.include?(tag.downcase))
          news_tags.push(tag)
       end
      end
      unless news_tags.empty?
        news.push({ datetime: date, news: { link: generate_url(url,news_link), name: news_headline }, tags: news_tags })
      end
    end
    news
  end

  def self.generate_url(url,path)
    if path.start_with?("http")
      return path
    else
      return url + path
    end
  end
end