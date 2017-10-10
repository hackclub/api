FROM ruby:2.3.1
MAINTAINER Zach Latta <zach@hackclub.com>

COPY vendor/wkhtmltox /tmp
RUN cd /tmp && tar xf wkhtmltox*.tar.xz && \
  mv wkhtmltox/bin/wkhtmltopdf /usr/bin/ && \
  chmod 555 /usr/bin/wkhtmltopdf

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev \
  postgresql-client ghostscript ledger zlib1g fontconfig \
  libfreetype6 libx11-6 libxext6 libxrender1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/Gemfile
ADD Gemfile.lock /usr/src/app/Gemfile.lock

ENV BUNDLE_GEMFILE=Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . /usr/src/app
