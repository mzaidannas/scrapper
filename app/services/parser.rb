# parser.rb
require 'digest/md5'

class Parser

  def self.parse(url, links, tag = 'Software')
    news = []
    date = Time.current
    tag_group = Tag.where(level: 0, name: tag).first
    tags = Tag.where(parent_id: tag_group.id).valid_tags.pluck(:name)
    tags.push(tag_group.name)
    ignored_tags = Tag.where(parent_id: tag_group.id).ignored_tags.pluck(:name)

    links.each do |link|
      news_link = link['href'].downcase
      news_headline = link.children.text

      ignore_headline = false
      ignored_tags.each do |tag|
        if (news_link && news_link.include?(tag.downcase)) ||
          (news_headline && news_headline.downcase.include?(tag.downcase))
          ignore_headline = true
          break
        end
      end
      next if ignore_headline

      news_tags = []
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

  def self.generate_url(url, path)
    if path.start_with?("http")
      return path
    else
      return url + path
    end
  end
end
