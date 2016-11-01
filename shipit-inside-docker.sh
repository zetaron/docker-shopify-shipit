#!/bin/sh

if [ ! -f /usr/src/shipit/.firstrun ]
then
    # wait for the redis server to be up
    while ! ping -c1 redis &>/dev/null; do :; done
    # wait for the postgres server to be up
    while ! ping -c1 postgres &>/dev/null; do :; done
    sleep 3 # give it another 3 seconds to completly boot
    bundle exec rake railties:install:migrations db:create db:migrate
    DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:setup

    bundle exec rake assets:precompile

    touch /usr/src/shipit/.firstrun
fi

bundle exec sidekiq -C config/sidekiq.yml &
bundle exec rails s -p $PORT
