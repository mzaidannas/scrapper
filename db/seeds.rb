
# create tag group
tag_group = TagGroup.where(name: 'Software', slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize).first_or_create

# create tags
tags = ['Java', 'Ruby', 'Rails', 'Linux', 'Apache', 'Ubuntu']
tags.each do |tag|
    Tag.where(name: tag, slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize, tag_group_id: tag_group.id).first_or_create
end

# create source
sources = [{name: 'Phoronix', url: 'https://www.phoronix.com'}]
sources.each do |source|
    Source.where(name: source[:name], slug: source[:name].gsub(/[^0-9a-z ]/i, '').parameterize, url: source[:url], tag_group_id: tag_group.id).first_or_create
end