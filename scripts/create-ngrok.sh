#!/usr/bin/env bash

PATH_NGROK="/home/vagrant/.config/ngrok"
PATH_CONFIG="${PATH_NGROK}/ngrok.yml"

# Only create a ngrok config file if there isn't one already there.
if [ ! -f $PATH_CONFIG ]; then
    mkdir -p "$PATH_NGROK"
    cat > "$PATH_CONFIG" << EOF
version: 2
web_addr: 0.0.0.0:4040
EOF
fi
