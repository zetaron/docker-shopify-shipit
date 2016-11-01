FROM ruby:2.2.5
RUN mkdir -p /usr/src/
WORKDIR /usr/src

RUN gem install rails -v 5.0.0.1 
RUN bundle config git.allow_insecure true \
    && git config --global user.email "shipit@zetaron.de" \
    && git config --global user.name "Shipit Deployment"
RUN wget https://raw.githubusercontent.com/Shopify/shipit-engine/master/template.rb \
    && rails _5.0.0.1_ new shipit -m template.rb
WORKDIR /usr/src/shipit
RUN sed -i "s/gem 'coffee-rails', '~> 4.2'/gem 'coffee-rails', '~> 4.1.0'/g" Gemfile \
    && echo "gem 'pg'" >> Gemfile \
    && echo "gem 'rails_12factor'" >> Gemfile
RUN [ -f Gemfile.lock ] && rm Gemfile.lock || true
RUN bundle install

ADD shipit-inside-docker.sh /usr/src/shipit/shipit-inside-docker.sh
CMD /usr/src/shipit/shipit-inside-docker.sh
