FROM ruby:2.7.5-alpine

# Setup build variables
ARG RAILS_ENV
ARG IM_VERSION=7.0.7-39

ENV APP_PRODUCTION=/data/ \
    APP_WORKDIR=/data

# Add backports to apt-get sources
# Install libraries, dependencies, java and fits

RUN apk update && \
        apk upgrade && \
        apk add bash build-base curl curl-dev gcompat imagemagick imagemagick-libs imagemagick-dev libarchive-tools  \
        libpq-dev libxml2-dev libxslt-dev nodejs openjdk11-jre-headless sqlite-dev tzdata yarn && \
        yarn config set no-progress && \
        yarn config set silent

# copy gemfiles to production folder
COPY Gemfile Gemfile.lock $APP_PRODUCTION

# install gems to system - use flags dependent on RAILS_ENV
RUN cd $APP_PRODUCTION && \
    bundle config build.nokogiri --use-system-libraries \
    && if [ "$RAILS_ENV" = "production" ]; then \
            bundle install --without test:development; \
        else \
            bundle install --without production --no-deployment; \
        fi \
    && mv Gemfile.lock Gemfile.lock.built_by_docker

# copy the application
COPY . $APP_PRODUCTION
COPY docker-entrypoint.sh /bin/

# use the just built Gemfile.lock, not the one copied into the container and verify the gems are correctly installed
RUN cd $APP_PRODUCTION \
    && mv Gemfile.lock.built_by_docker Gemfile.lock \
    && bundle check

# generate production assets if production environment
RUN if [ "$RAILS_ENV" = "production" ]; then \
        cd $APP_PRODUCTION \
        && yarn install \
        && SECRET_KEY_BASE_PRODUCTION=0 bundle exec rake assets:clean assets:precompile; \
    fi

WORKDIR $APP_WORKDIR

RUN chmod +x /bin/docker-entrypoint.sh
