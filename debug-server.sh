#!/usr/bin/env sh
node --inspect=$SSB_DEBUG_PORT --debug-brk /scuttlebot/bin.js server --path /shared/$SSB_HOST/.ssb --port $SSB_SERVER_PORT
