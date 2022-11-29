# Admin user
User.create_with(name: 'Admin User', password: 'suhprod').find_or_create_by!(email: 'admin@scrapper.com')

# create tag group
tag_group = Tag.create_with(name: 'Software').find_or_create_by!(slug: 'Software'.gsub(/[^0-9a-z ]/i, '').parameterize)
Tag.create_with(name: 'Hardware').find_or_create_by!(slug: 'Hardware'.gsub(/[^0-9a-z ]/i, '').parameterize)

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
  Tag.create_with(name: tag, parent: tag_group).find_or_create_by!(slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize)
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
  Tag.create_with(name: tag, parent: tag_group, to_ignore: true).find_or_create_by!(slug: tag.gsub(/[^0-9a-z ]/i, '').parameterize)
end

# create source
sources = [
  {name: 'Phoronix', url: 'https://www.phoronix.com'},
  {name: 'Arstechnica', url: 'https://arstechnica.com', logo_url: 'https://www.vectorlogo.zone/logos/arstechnica/arstechnica-icon.svg'},
  {name: 'TechCrunch', url: 'https://techcrunch.com', logo_url: 'https://www.vectorlogo.zone/logos/techcrunch/techcrunch-icon.svg'},
  {name: 'Engadget', url: 'https://www.engadget.com', logo_url: 'https://www.vectorlogo.zone/logos/engadget/engadget-ar21.svg'},
  {name: 'TheNextWeb', url: 'https://thenextweb.com', logo_url: 'https://www.vectorlogo.zone/logos/thenextweb/thenextweb-ar21.svg'},
  {name: 'Wired', url: 'https://www.wired.com', logo_url: 'https://www.vectorlogo.zone/logos/wired/wired-ar21.svg'},
  {name: 'Digital Ocean Community', url: 'https://www.digitalocean.com/community', logo_url: 'https://www.vectorlogo.zone/logos/digitalocean/digitalocean-icon.svg'},
  {name: 'Hacker News', url: 'https://news.ycombinator.com/news', logo_url: 'https://www.vectorlogo.zone/logos/ycombinator/ycombinator-icon.svg'},
  {name: 'Frontend Mastery', url: 'https://frontendmastery.com', logo_url: 'https://scrapper-resources.s3.ap-south-1.amazonaws.com/frontend_mastery.svg'},
  {name: 'Cloudflare Blog', url: 'https://blog.cloudflare.com', logo_url: 'https://www.vectorlogo.zone/logos/cloudflare/cloudflare-icon.svg'},
  {name: 'GHacks', url: 'https://www.ghacks.net', logo_url: 'https://scrapper-resources.s3.ap-south-1.amazonaws.com/ghacks.svg'},
  {name: 'InfoQ', url: 'https://www.infoq.com/news'},
  {name: 'Facebook Blog', url: 'https://engineering.fb.com', logo_url: 'https://www.svgrepo.com/show/158427/facebook.svg'},
  {name: 'Hackaday Blog', url: 'https://hackaday.com/blog', logo_url: 'https://www.svgrepo.com/download/306167/hackaday.svg'}

  # need xml/rss crawlers
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
  # { name: 'JavaScript Weekly', url: 'https://cprss.s3.amazonaws.com/javascriptweekly.com.xml' },
]
sources.each do |source|
  Source.create_with(name: source[:name], url: source[:url], tag: tag_group, logo_url: source[:logo_url])
    .find_or_create_by!(slug: source[:name].gsub(/[^0-9a-z ]/i, '').parameterize)
end
