FROM node:6.9

MAINTAINER Don Smith <don@antiantonym.com>

RUN git clone https://github.com/ssbc/scuttlebot.git

WORKDIR /scuttlebot

# Create our own SSB network
# so we don't interfere with
# the default SSB network
COPY ssb-cap.js lib

RUN npm install
RUN npm install
