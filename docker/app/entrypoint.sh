#!/bin/sh
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# No need to seed to prepare database in production/staging
if [[ "$RAILS_ENV" == "test" ]]
then
  bundle exec rails db:create 2>/dev/null
	bundle exec rails db:test:prepare 2>/dev/null
else
  bundle exec rails db:migrate 2>/dev/null
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
