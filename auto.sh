#!/bin/bash
cd /home/hmontana/sbgameapi
source ./venv/bin/activate
gunicorn --certfile /home/hmontana/.local/share/mkcert/172.16.139.69.pem --keyfile /home/hmontana/.local/share/mkcert/172.16.139.69-key.pem -b 0.0.0.0:5000 api:app
