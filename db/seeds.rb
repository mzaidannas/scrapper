# Admin user
user = User.create_with(name: 'Admin User', password: 'suhprod').find_or_create_by!(email: 'admin@scrapper.com')

# create tag group
tag_group = Tag.where(name: 'Software', slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize).first_or_create!

# create tags
tags = %w[
  Java Ruby Rails PHP Laravel Zend Python Groovy Swift Go Kotlin Matlab TypeScript Scala Script Basic Dart
  Javascript Angular Vue React V8 Node 
  Database SQL Postgres SingleStore DB
  Apache Elasticsearch Nginx Android Ios Redis Bash Terminal Shell Host
  Linux Ubuntu Windows Azure AWS Mac PC Computer 
  YouTube Facebook Linkedin Twitter Instagram Snapchat TikTok
  Adobe Google Microsoft Oracle Amazon IBM Huawei Samsung Norton Xiaomi 
  ERP SAP Salesforce CRM CAD Web Desktop Mobile Graphics SAAS Agile Waterfall
  Soft Hardware Source Piracy Privacy Virus Tech Ecommerce
  Gaming Game Graphics Audio Video 3d Engine Stadia Xbox PlayStation
  Developer Development Language Programming Program Architecture Telescope USB UI UX
]
tags.each do |tag|
  Tag.where(name: tag, slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize, parent: tag_group).first_or_create!
end

# create source
sources = [
  { name: 'Phoronix', url: 'https://www.phoronix.com' },
  { name: 'Arstechnica', url: 'https://arstechnica.com' },
  { name: 'TechCrunch', url: 'https://techcrunch.com' },
  { name: 'Engadget', url: 'https://www.engadget.com' },
  { name: 'TheNextWeb', url: 'https://thenextweb.com' },
  { name: 'Wired', url: 'https://www.wired.com' },
  { name: 'Digital Ocean Community', url: 'https://www.digitalocean.com/community' },
  { name: 'Hacker News', url: 'https://news.ycombinator.com' },

  # need xml crawlers
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
]
sources.each do |source|
  Source.where(name: source[:name], slug: source[:name].gsub(/[^0-9a-z ]/i, '').parameterize, url: source[:url],
               tag: tag_group).first_or_create!
end
