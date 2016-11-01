#!/bin/sh

if [ ! -f /usr/src/shipit/.firstrun ]
then
    sleep 3 # wait for postgres to be started
    bundle exec rake railties:install:migrations db:create db:migrate
    DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:setup

    bundle exec rake assets:precompile

    touch /usr/src/shipit/.firstrun
fi

bundle exec sidekiq -C config/sidekiq.yml &
bundle exec rails s -p $PORT
