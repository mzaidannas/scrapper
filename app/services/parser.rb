# parser.rb
require 'digest/md5'

class Parser

  def self.parse(url, links, tag_group = 'Software')
    news = []
    date = DateTime.current
    tags = TagGroup.where(name: tag_group).first.tags.pluck(:name)

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
        link_url = generate_url(url,news_link)
        news.push({ 
          datetime: date, 
          news: { 
            slug: Digest::MD5.hexdigest(link_url), 
            link: link_url, 
            name: news_headline }, 
          tags: news_tags 
        })
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