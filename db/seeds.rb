# Admin user
user = User.create_with(name: 'Admin User', password: 'suhprod').find_or_create_by!(email: 'admin@scrapper.com')

# create tag group
tag_group = Tag.where(name: 'Software', slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize).first_or_create!

# create tags
tags = %w[Java Ruby Rails Linux Apache Ubuntu]
tags.each do |tag|
  Tag.where(name: tag, slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize, parent: tag_group).first_or_create!
end

# create source
sources = [{ name: 'Phoronix', url: 'https://www.phoronix.com' }]
sources.each do |source|
  Source.where(name: source[:name], slug: source[:name].gsub(/[^0-9a-z ]/i, '').parameterize, url: source[:url],
               tag: tag_group).first_or_create!
end
