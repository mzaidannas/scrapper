# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

tag_group = TagGroup.where(name: 'Software', slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize).first_or_create

tags = ['Java', 'Ruby', 'Rails', 'Linux', 'Apache']
tags.each do |tag|
    Tag.where(name: tag, slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize, tag_group_id: tag_group.id).first_or_create
end