# syntax = docker/dockerfile:1

# NB: At the moment, we make no effort to minimize the image size because we
# want all the development tools available in the dev image

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION

# Rails app lives here
WORKDIR /rails

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_JOBS="4"

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential pkg-config libsqlite3-0

# Deployment options
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true"

# Install application gems - set BUNDLE_DATE to force re-installing gems
ARG BUNDLE_DATE=now
ENV BUNDLE_DATE=$BUNDLE_DATE
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile

# Run and own only the runtime files as a non-root user for security (after bundler)
RUN useradd rails --create-home --shell /bin/bash
USER rails:rails

# Entrypoint prepares the database - runs rake db:prepare - figure out something
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
