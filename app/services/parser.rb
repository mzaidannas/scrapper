# parser.rb
require 'digest/md5'

class Parser

  def self.parse(url, links, tag = 'Software')
    news = []
    date = Time.current.to_s(:db)
    tag_group = Tag.where(level: 0, name: tag).first
    tag_models = Tag.where(parent_id: tag_group.id).valid_tags
    tag_models = ([tag_models] + [tag_group]).flatten
    ignored_tags = Tag.where(parent_id: tag_group.id).ignored_tags.pluck(:name)

    links.each do |link|
      next if link.nil? || link['href'].nil? ||
        link.children.nil? || link.children.text.nil? || link.children.text.empty?

      news_link = link['href'] || ""
      news_headline = link.children.text || ""
      news_link_words = news_link.split(/[^a-zA-Z\d]/).uniq.compact
      news_headline_words = news_headline.split(/[^a-zA-Z\d]/).uniq.compact

      ignore_headline = false
      ignored_tags.each do |tag|
        if (news_link.downcase.include?(tag.downcase)) ||
          (news_headline && news_headline.downcase.include?(tag.downcase))
          ignore_headline = true
          break
        end
      end
      next if ignore_headline

      news_tags = []
      tag_models.each do |tag|
        orig_tag_name = tag.name
        tag_name = tag.name.strip
        tag_name = tag_name.downcase unless tag.case_sensitive
        if tag.whole_word
          news_link_words.each do |news_link_word|
            news_link_word = news_link_word.downcase unless tag.case_sensitive
            if (news_link_word.strip.include?(tag_name))
              news_tags.push(orig_tag_name)
            end
          end
          news_headline_words.each do |news_headline_word|
            news_headline_word = news_headline_word.downcase unless tag.case_sensitive
            if (news_headline_word.strip.include?(tag_name))
              news_tags.push(orig_tag_name)
            end
          end
        end
        if tag.starting
          news_link_words.each do |news_link_word|
            news_link_word = news_link_word.downcase unless tag.case_sensitive
            if (news_link_word.strip.starts_with?(tag_name))
              news_tags.push(orig_tag_name)
            end
          end
          news_headline_words.each do |news_headline_word|
            news_headline_word = news_headline_word.downcase unless tag.case_sensitive
            if (news_headline_word.strip.starts_with?(tag_name))
              news_tags.push(orig_tag_name)
            end
          end
        end
        if tag.ending
          news_link_words.each do |news_link_word|
            news_link_word = news_link_word.downcase unless tag.case_sensitive
            if (news_link_word.strip.end_with?(tag_name))
              news_tags.push(orig_tag_name)
            end
          end
          news_headline_words.each do |news_headline_word|
            news_headline_word = news_headline_word.downcase unless tag.case_sensitive
            if (news_headline_word.strip.end_with?(tag_name))
              news_tags.push(orig_tag_name)
            end
          end
        end
      end

      news_tags = news_tags.uniq.compact

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
