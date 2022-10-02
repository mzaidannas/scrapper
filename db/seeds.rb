# Admin user
user = User.create_with(name: 'Admin User', password: 'suhprod').find_or_create_by!(email: 'admin@scrapper.com')

# create tag group
tag_group = Tag.where(name: 'Software', slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize).first_or_create!

# create tags
tags = %w[
  Java Spring Boot Ruby Rails PHP Laravel Zend Python Groovy Swift Golang Kotlin Matlab TypeScript Scala Script Basic Dart Carbon
  Javascript Angular Vue React V8 Node.js
  Database SQL Postgres SingleStore Migration CockroachDB NoSQL MySQL
  DevOps
  Test Framework Infrastructure
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
  Tag.where(name: tag, slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize, parent: tag_group).first_or_create!
end

# create TO IGNORE tags
tags = %w[
  tiktok.com twitter.com facebook.com instagram.com reddit.com youtube.com 
  snapchat.com github.com spotify.com t.me amazon.com linkedin.com
  Cookie Ad\ Choices donate
  contact\ us about\ us feedback Customer\ Care Newsletter
  Featured\ Videos Featured\ News category
  Headlines Reviews Guidelines FAQ hours\ ago hour\ ago
  Sign\ Up Sign\ In Sign\ Out Log\ Out author RSS
]
tags.each do |tag|
  Tag.where(name: tag, slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize, parent: tag_group, to_ignore: true).first_or_create!
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
  { name: 'Hacker News', url: 'https://news.ycombinator.com/news' },
  { name: 'Frontend Mastery', url: 'https://frontendmastery.com' },
  { name: 'Cloudflare Blog', url: 'https://blog.cloudflare.com' },
  { name: 'GHacks', url: 'https://www.ghacks.net' },
  { name: 'InfoQ', url: 'https://www.infoq.com/news' },

  # need xml/rss crawlers
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
]
sources.each do |source|
  Source.where(name: source[:name], slug: source[:name].gsub(/[^0-9a-z ]/i, '').parameterize, url: source[:url],
               tag: tag_group).first_or_create!
end
