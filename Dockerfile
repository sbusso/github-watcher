FROM ruby:2.3-alpine 
MAINTAINER Stephane Busso <stephane.busso@gmail.com>

RUN apk update && apk upgrade && apk add curl wget bash git

# Clean APK cache
RUN rm -rf /var/cache/apk/*

RUN mkdir /app 
WORKDIR /app

ADD Gemfile /app/ 
ADD Gemfile.lock /app/ 
RUN bundle install

ADD . /app

CMD rake