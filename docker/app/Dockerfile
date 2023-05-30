# Using alpine image for small size
FROM ruby-3.2.2-alpine

# Use virtual build-dependencies tag so we can remove these packages after bundle install
RUN apk update && apk add --update --no-cache --virtual build-dependency libxml2-dev libxslt-dev build-base ruby-dev postgresql-dev git shared-mime-info

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/scrapper

# make a new directory where our project will be copied
RUN mkdir -p $RAILS_ROOT/tmp/pids

# Set working directory within container
WORKDIR $RAILS_ROOT

# Setting env up
ARG RAILS_ENV
ENV RAILS_ENV $RAILS_ENV
ENV RAKE_ENV $RAILS_ENV
ENV RACK_ENV $RAILS_ENV
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler -v 2.3.21

# nokogiri now bundles its own libxml2, which doesn't compile on alpine
RUN bundle config build.nokogiri --use-system-libraries

# development/production differs in bundle install
RUN if [[ "$RAILS_ENV" == "development" ]]; then\
 bundle check || bundle install;\
 elif [[ "$RAILS_ENV" == "test" ]]; then\
 bundle check || bundle install --jobs 4 --retry 5 --without development;\
 else bundle check || bundle install --jobs 4 --retry 5 --without development test; fi

# Remove build dependencies and install runtime dependencies
RUN apk del build-dependency
RUN apk add --update libxml2 libxslt shared-mime-info postgresql-client postgresql-libs nodejs yarn tzdata libcurl git

# Adding project files
COPY . .

RUN if [[ "$RAILS_ENV" != "development" ]]; then\
 bundle exec rails assets:precompile; \
 else yarn; fi

EXPOSE 3000
