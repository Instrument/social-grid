#!/bin/sh

curl -X DELETE "https://api.instagram.com/v1/subscriptions?object=all&client_id=6bd3b25920394891bcd71b933ee948cc&client_secret=2782e585026f4371bb8e47bcf5079926"

forever stop /opt/mfnw/server/server.js;