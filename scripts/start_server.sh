#!/bin/bash
pid=$(lsof -ti tcp:8080)
if [[ $pid ]]; then
  kill -9 $pid
fi
cd /home/ubuntu/jaams/webserver
export GOOGLE_APPLICATION_CREDENTIALS="/home/ubuntu/jaams/webserver/<google-cloud-server-credentions.json>"
nohup node index.js > /dev/null 2>/var/log/app.log &
