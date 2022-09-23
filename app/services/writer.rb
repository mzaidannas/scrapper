# writer.rb

class Writer

  def self.write(source_slug, news, tag)
    tags = Tag.find_by(name: tag).self_and_descendants.pluck(:name, :id).to_h
    news.each do |n|
      ScrapedNews.transaction do
        # save news
        news_model = ScrapedNews.where(slug: n[:news][:slug]).first_or_initialize
        news_model.headline = n[:news][:name]
        news_model.link = n[:news][:link]
        news_model.datetime = n[:datetime] if news_model.new_record?

        # save related tags
        n[:tags].each do |tag|
          news_model.news_tags.new(tag_id: tags[tag])
        end

        # save related sources
        source = Source.find_by(slug: source_slug)
        news_model.news_sources.new(source_id: source.id)

        news_model.save!
      end
    end
    true
  end
end
