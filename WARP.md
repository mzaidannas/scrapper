# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project type: Ruby on Rails 8 app with Sidekiq, Avo admin, Devise auth, Tailwind (via Bun), and a scraping pipeline.

Common commands
- Setup
  - Bundle gems: bundle install
  - JS deps (Bun): bun install
  - DB setup (create, load schema, seed): bin/rails db:setup
  - Migrate: bin/rails db:migrate
- Run (local, without Docker)
  - Web: bin/rails server -p 3000
  - Assets (Tailwind via Bun): bun run build --watch
  - Sidekiq worker: bundle exec sidekiq -C config/sidekiq.yml
- Run (Docker)
  - Build and start full stack (app, assets, worker, nginx, postgres, redis): docker compose up --build
  - Only services for local deps: docker compose up postgres redis
  - Production profile locally: docker compose -f docker-compose-prod.yml up --build
- Lint/format
  - Lint: bin/rubocop
  - Autofix (where safe): bin/rubocop -A
- Tests
  - All tests: bin/rails test
  - Single file: bin/rails test test/models/scraped_news_test.rb
  - Single test by line: bin/rails test test/models/scraped_news_test.rb:12
  - System tests: bin/rails test:system
- Admin/ops
  - Sync Sidekiq cron jobs from sources: bin/rake update_all_jobs
  - Rails console: bin/rails console
  - Run a job immediately: bin/rails runner "ScrapeSourceJob.perform_now('SOURCE_NAME','TAG_NAME')"

High-level architecture
- Data model (core)
  - Tag: hierarchical taxonomy (includes HierarchicalModel concern) with scopes:
    - valid_tags: enabled, not ignored
    - ignored_tags: enabled, marked to_ignore
  - Source: belongs_to Tag; schedule enum (hourly/daily/weekly/monthly/yearly); after commit, creates/updates Sidekiq::Cron job to enqueue ScrapeSourceJob with the source’s name and tag
  - ScrapedNews: deduped by slug; has_many through NewsTag and NewsSource to Tags and Sources
  - NewsTag and NewsSource: join models; uniqueness per [scraped_news_id, tag_id] and [scraped_news_id, source_id] respectively
- Scraping pipeline (services)
  - Scraper (app/services/scraper.rb): fetches a page (Nokogiri + open-uri) and returns <a> elements
  - Parser (app/services/parser.rb):
    - Computes tags per link/headline against Tag rules (case sensitivity, whole_word, starting, ending)
    - Filters ignored tags
    - Generates absolute link URLs and a slug (MD5 of link)
    - Outputs structured items: { datetime, news: { slug, link, name }, tags: [...] }
  - Writer (app/services/writer.rb):
    - Filters against IgnoredLink entries (global and per-source) using literal and regex checks
    - Upserts ScrapedNews, associated NewsTag, and NewsSource in a transaction
- Jobs and scheduling
  - ScrapeSourceJob: orchestrates Scraper -> Parser -> Writer for a given Source and Tag
  - JobRunsMaintenanceJob: invokes JobRun.maintenance (Sidekiq job for maintenance)
  - Scheduling via sidekiq-cron; Source.update_cron_job and lib/tasks/update_all_jobs.rake keep cron schedule synced with DB state
  - Sidekiq queues configured in config/sidekiq.yml (default and other named queues)
- Web/admin/auth
  - Devise provides authentication; Sidekiq Web UI and Avo admin are mounted behind authenticate :user
  - Routes: root to Avo home; authenticated mounts for /sidekiq and Avo at Avo.configuration.root_path
  - Avo resource example: ScrapedNewsResource with custom search, tag/source assignment fields, and an ExportCsv action
- Runtime and assets
  - Web server: Puma (config/puma.rb); supports embedded Sidekiq via plugin when SIDEKIQ_EMBEDDED is set
  - Assets: Tailwind v4 and PostCSS built with Bun (scripts: package.json; watcher in Procfile.dev)
- Containers (docker/)
  - docker-compose.yml: services for postgres, redis, assets builder (bun), app (Rails), worker (Sidekiq), and nginx-based web
  - docker-compose-prod.yml: production-oriented app/worker using Dockerfile.prod; requires RAILS_MASTER_KEY and service URLs

Conventions and notes
- Linting: Standard + RuboCop Rails (see .rubocop.yml). Use bin/rubocop locally; exclude lists include db/schema.rb, db/migrate, bin/*
- Admin access: Avo and Sidekiq Web require a logged-in user (Devise). Create a user via console if needed
- Cron sync: if Source records change (schedule/enabled/tag), run bin/rake update_all_jobs to refresh Sidekiq-Cron entries
- Procfile.dev defines convenient processes (web, assets). Use a Procfile runner if preferred, or start processes separately as listed above

