#!/usr/bin/env sh
node --inspect=$SSB_DEBUG_PORT --debug-brk /scuttlebot/bin.js server --allowPrivate --port $SSB_SERVER_PORT
