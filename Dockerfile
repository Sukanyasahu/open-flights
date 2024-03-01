# Make sure it matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.1.4-node
FROM ruby:$RUBY_VERSION

RUN apt-get update –qq && \ 
apt-get install -y build-essential libvips && \
apt-get clean && \
yarn Install

ENV BUNDLE_JOBS: 3
    BUNDLE_RETRY: 3
    BUNDLE_PATH: vendor/bundle
    PGHOST: 127.0.0.1
    PGUSER: open-flights
    PGPASSWORD: ""
    RAILS_ENV: test

WORKDIR $

COPY Gemfile Gemfile.lock ./
RUN bundle install

#Copy application code
COPY ..

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile –gemfile app/ lib/

# Precompile assets for production without requiring secret
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile


ENTRYPOINT [“bundle”, “exec”]

# Make port 80 available to the world outside this container
EXPOSE $RAILS_PORT 

#Run app.py when the container launches
CMD ["python", "app.py"]

