# writer.rb

class Writer

  def self.write(source_slug, news, tag_group)
    tags = TagGroup.where(name: tag_group).first.tags.map { |t| [t[:name],t[:id]]}.to_h
    news.each do |n|
      # save news
      news_model = ScrapedNews.where(slug: n[:news][:slug]).first_or_initialize
      news_model.headline = n[:news][:name]
      news_model.link = n[:news][:link]
      news_model.datetime = n[:datetime] if news_model.new_record?
      news_model.save

      # save related tags
      n[:tags].each do |tag|
        news_model.news_tags.create(tag_id: tags[tag])
      end

      # save related sources
      source = Source.where(slug: source_slug).first
      news_model.news_sources.create(source_id: source.id)
    end
    true
  end
end