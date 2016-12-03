FROM ubuntu:latest

MAINTAINER Luis Gil Guijarro <luisgguijarro9@gmail.com>


ARG TOKEN
ARG TOKEN_TASTEKID
ARG POSTGRES_DATABASE

ENV TOKEN=$TOKEN
ENV TOKEN_TASTEKID=$TOKEN_TASTEKID
ENV POSTGRES_DATABASE=$POSTGRES_DATABASE


RUN apt-get update
RUN apt-get install -y git ruby ruby-dev build-essential libpq-dev

RUN gem install bundler

RUN git clone https://github.com/LuisGi93/proyectoIV2016-2017
WORKDIR proyectoIV2016-2017
RUN bundle install
