# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t cheeseformice .
# docker run -d -p 80:80 -p 443:443 --name cheeseformice cheeseformice

# Make sure to build the image correctly by using bin/build, otherwise the required ARGs won't be set
# The warning about the missing ARG can be ignored, as they are set in the build script
ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Install base packages needed in both following stages, then remove any extra files / caches that are not
# needed anymore to reduce image size
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


# Throw-away build stage to reduce size of final image. Ultimately, only the built artifacts are copied over.
FROM base AS build

# Install packages needed to build gems and node modules, then delete caches to reduce image size
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev node-gyp pkg-config \
                                               python-is-python3 libyaml-dev default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install JavaScript dependencies, then delete temporary files to reduce image size
ARG NODE_VERSION
ARG YARN_VERSION
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "$NODE_VERSION" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /usr/local/node/lib/node_modules/npm /tmp/node-build-master

# Install application gems, then delete caches to reduce image size
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Copy application.example.yml to application.yml for default values as preparation for asset precompilation
# (since precompilation requires some ENV variables like APP_HOST to be set), then precompile the assets for
# production without requiring secret RAILS_MASTER_KEY and remove the application.yml again
RUN rm -f public/assets/.sprockets-manifest-*.json && \
    cp config/application.example.yml config/application.yml && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    rm config/application.yml

# Remove any temporary files to reduce image size
RUN rm -rf node_modules

# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y postgresql-client libmariadb3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Copy node and set it into the path to ensure it's available in the final stage as well
COPY --from=build /usr/local/node /usr/local/node
ENV PATH=/usr/local/node/bin:$PATH

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp public/assets
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
# Note: We're exposing port 80 here instead of 3000, as Kamal expects the app to run on port 80
EXPOSE 80
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "80"]

# Configure a healthcheck for Kamal to check if the app is up and running
HEALTHCHECK CMD curl -f http://localhost:80/up || exit 1
