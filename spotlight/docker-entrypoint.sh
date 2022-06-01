#!/bin/bash

echo "current env $RAILS_ENV"
echo "Creating log folder"
mkdir -p $APP_WORKDIR/log

echo "check bundle"
if [ "$RAILS_ENV" = "production" ]; then
    # Verify all the production gems are installed
    bundle check
else
    # install any missing development gems (as we can tweak the development container without rebuilding it)
    bundle check || bundle install --without production
fi

## Run any pending migrations, if the database exists
## If not setup the database
echo "setup db"
bundle exec rake db:exists && bundle exec rake db:migrate || bundle exec rake db:setup

# setup test db for unit test
if [ "$RAILS_ENV" != "production" ]; then
  echo "setup test db for unit testing"
  bundle exec rake db:setup RAILS_ENV=test
  bundle exec rake db:migrate RAILS_ENV=test
fi

# echo "Setting up spotlight... (this can take a few minutes)"
# bundle exec rake spotlight:setup_spotlight["seed/setup.json"]
npm install --unsafe-perm  # install uv, --unsafe-perm for root permission

echo "--------- Starting Spotlight in $RAILS_ENV mode ---------"
rm -f /tmp/spotlight.pid
bundle exec rails server -p 3005 -b '0.0.0.0' --pid /tmp/spotlight.pid

