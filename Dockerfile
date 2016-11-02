FROM ruby:2.2.5-alpine
RUN mkdir -p /usr/src/
WORKDIR /usr/src

RUN apk add --no-cache alpine-sdk \
    && gem install rails -v 5.0.0.1 \
    && bundle config git.allow_insecure true \
    && git config --global user.email "shipit@zetaron.de" \
    && git config --global user.name "Shipit Deployment" \
    && wget https://raw.githubusercontent.com/Shopify/shipit-engine/master/template.rb \
    && rails _5.0.0.1_ new shipit -m template.rb \
    && apk del alpine-sdk

WORKDIR /usr/src/shipit

RUN sed -i "s/gem 'coffee-rails', '~> 4.2'/gem 'coffee-rails', '~> 4.1.0'/g" Gemfile \
    && sed -i "s/gem 'sqlite3'//g" Gemfile \
    && echo "gem 'pg'" >> Gemfile \
    && echo "gem 'rails_12factor'" >> Gemfile

RUN apk add --no-cache \
    alpine-sdk \
    postgresql-dev \
    && bundle install \
    && apk del alpine-sdk

RUN apk add --no-cache git

ADD shipit-inside-docker.sh /usr/src/shipit/shipit-inside-docker.sh
CMD /usr/src/shipit/shipit-inside-docker.sh
