# writer.rb

class Writer
  def self.write(source_slug, news, tag)
    tags = Tag.find_by(name: tag).self_and_descendants.pluck(:name, :id).to_h
    source = Source.find_by(slug: source_slug)
    ignored_links = IgnoredLink.where(global: true)
    ignored_links += IgnoredLink.where(global: false).where(source_id: source.id)
    link_ignored_links = ignored_links.pluck(:link).uniq.compact
    regex_ignored_links = ignored_links.pluck(:regex).uniq.compact

    news.each do |n|
      # match ignored list and ignored regex
      ignore_news = false
      link_ignored_links.each do |link_ignored_link|
        if link_ignored_link.downcase.include? n[:news][:link].downcase
          ignore_news = true
          break
        end
      end
      unless ignore_news
        regex_ignored_links.each do |regex_ignored_link|
          re = Regexp.new regex_ignored_link
          unless (regex_ignored_links.match re).nil?
            ignore_news = true
            break
          end
        end
      end
      next if ignore_news

      ScrapedNews.transaction do
        # save news
        news_model = ScrapedNews.where(slug: n[:news][:slug]).first_or_initialize
        news_model.headline = n[:news][:name]
        news_model.link = n[:news][:link]
        news_model.datetime = n[:datetime] if news_model.new_record?

        # save related tags
        n[:tags].each do |tag|
          news_model.news_tags.find_or_initialize_by(tag_id: tags[tag])
        end

        # save related sources
        news_model.news_sources.find_or_initialize_by(source_id: source.id)

        news_model.save!
      end
    end
    true
  end
end
