# Admin user
User.create_with(name: 'Admin User', password: 'suhprod').find_or_create_by!(email: 'admin@scrapper.com')

# create tag group
tag_group = Tag.create_with(name: 'Software').find_or_create_by!(slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize)
Tag.create_with(name: 'Hardware').find_or_create_by!(slug: 'Hardware'.gsub(/[^0-9a-z ]/i, '').parameterize)

# create tags
tags = %w[
  Java Spring Boot Ruby Rails PHP Laravel Zend Python Groovy Swift Golang Kotlin Matlab TypeScript Scala Script Basic Dart Carbon
  Javascript Angular Vue React V8 Node.js
  Database DB SQL Postgres SingleStore Migration CockroachDB NoSQL MySQL
  DevOps
  Infrastructure
  Tree Stack Queue Sort Search Algorithm Object Pointer Class Interface Inherit
  Apache Elasticsearch Nginx Android iPhone iPad Ios Redis Bash Terminal Shell Server Serverless
  Linux Ubuntu Windows Azure AWS Mac PC Computer Computing
  YouTube Facebook Linkedin Twitter Instagram Snapchat TikTok GitHub Telegram Signal WhatsApp SpaceX Startup
  Paypal Payoneer Shopify Skrill QuickBooks
  Adobe Google Microsoft Oracle Amazon IBM Huawei Samsung Norton Xiaomi Intel AMD Spotify Nvidia
  ERP SAP Salesforce CRM CAD Web Desktop Mobile Graphics SAAS Agile Waterfall Cloud Cloudflare Internet
  Hardware Open\ Source Piracy Virus Technology Ecommerce System Interview
  Memory SSD Storage CPU Modem 5G 4G Bluetooth
  Gaming Game Graphics Audio Video Engine Stadia Xbox PlayStation Wii VR
  Developer Development Language Programming Program Architecture Telescope USB UI UX Bot
  Byte Bit Data Information
  Encrypt Dycrypt Leak Torrent LastPass KeyBase Zip Compression Hacked Cyberattack Security
  Crypto Blockchain
  NPM Composer Yarn
  Browser FTP Chrome Firefox Safari chromium
]
tags.each do |tag|
  Tag.create_with(name: tag, parent: tag_group).find_or_create_by!(slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize)
end

# create TO IGNORE tags
tags = %w[
  Cookie Ad\ Choices donate
  contact\ us about\ us feedback Customer\ Care Newsletter
  Featured\ Videos Featured\ News category
  Headlines Reviews Guidelines FAQ hours\ ago hour\ ago
  Sign\ Up Sign\ In Sign\ Out Log\ Out author RSS
]
tags.each do |tag|
  Tag.create_with(name: tag, parent: tag_group, to_ignore: true).find_or_create_by!(slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize)
end

ignored_links = %w[
  tiktok.com twitter.com facebook.com instagram.com reddit.com youtube.com
  snapchat.com github.com spotify.com t.me amazon.com linkedin.com
]
ignored_links.each do |ignored_link|
  IgnoredLink.where(link: ignored_link, global: true).first_or_create!
end

# create source
sources = [
  {name: 'Phoronix', url: 'https://www.phoronix.com', ignored_links: []},
  {name: 'Arstechnica', url: 'https://arstechnica.com', ignored_links: []},
  {name: 'TechCrunch', url: 'https://techcrunch.com', ignored_links: []},
  {name: 'Engadget', url: 'https://www.engadget.com', ignored_links: []},
  {name: 'TheNextWeb', url: 'https://thenextweb.com', ignored_links: []},
  {name: 'Wired', url: 'https://www.wired.com', ignored_links: []},
  {name: 'Digital Ocean Community', url: 'https://www.digitalocean.com/community', ignored_links: []},
  {name: 'Hacker News', url: 'https://news.ycombinator.com/news', ignored_links: []},
  {name: 'Frontend Mastery', url: 'https://frontendmastery.com', ignored_links: []},
  {name: 'Cloudflare Blog', url: 'https://blog.cloudflare.com', ignored_links: []},
  {name: 'GHacks', url: 'https://www.ghacks.net', ignored_links: []},
  {name: 'InfoQ', url: 'https://www.infoq.com/news', ignored_links: []}

  # need xml/rss crawlers
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
]
sources.each do |source|
  Source.create_with(name: source[:name], url: source[:url], tag: tag_group, logo_url: source[:logo_url])
    .find_or_create_by!(slug: source[:name].gsub(/[^0-9a-z ]/i, '').parameterize)
end
