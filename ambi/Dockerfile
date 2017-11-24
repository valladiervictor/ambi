FROM ruby:2.3-alpine
MAINTAINER Adrien Hamraoui <dev@hamadr.fr>
LABEL maintainer "Adrien Hamraoui <dev@hamadr.fr>"
LABEL name "L'Ambianceur"

WORKDIR /app/

COPY Gemfile Gemfile.lock /app/

RUN set -x \
  && apk add --no-cache --virtual build-dep \
    build-base \
    sqlite-dev \
    sqlite-libs \
    libxml2-dev \
    libxslt-dev \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle install --without development test \
  && apk del build-dep \
&& rm -rf /var/cache/apk/*

COPY . /app

RUN apk add --no-cache sqlite-libs libxslt nodejs tzdata

#RUN set -x \
#  && apk add --no-cache --virtual assets-precompile-dep \
#  && RAILS_LOG_TO_STDOUT=true \
#    RAILS_ENV=production \
#    rake assets:precompile \
#  && apk del assets-precompile-dep

EXPOSE 3000
ENV RAILS_ENV production
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
