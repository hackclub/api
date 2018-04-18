FROM ruby:2.3.1
MAINTAINER Zach Latta <zach@hackclub.com>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
  postgresql-client ghostscript ledger zlib1g fontconfig \
  libfreetype6 libx11-6 libxext6 libxrender1 --no-install-recommends

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock

ENV BUNDLE_GEMFILE=Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . /usr/src/app

ENTRYPOINT bin/rails server -p $PORT -e $RAILS_ENV
