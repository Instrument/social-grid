#!/bin/sh

curl -X DELETE "https://api.instagram.com/v1/subscriptions?object=all&client_id=6bd3b25920394891bcd71b933ee948cc&client_secret=2782e585026f4371bb8e47bcf5079926"

curl -F "client_id=6bd3b25920394891bcd71b933ee948cc" \
     -F "client_secret=2782e585026f4371bb8e47bcf5079926" \
     -F 'object=tag' \
     -F 'aspect=media' \
     -F 'object_id=mfnw' \
     -F "callback_url=http://ec2-50-112-66-228.us-west-2.compute.amazonaws.com:1337/instagram" \
https://api.instagram.com/v1/subscriptions/

curl -F "client_id=6bd3b25920394891bcd71b933ee948cc" \
     -F "client_secret=2782e585026f4371bb8e47bcf5079926" \
     -F 'object=tag' \
     -F 'aspect=media' \
     -F 'object_id=pdxconf' \
     -F "callback_url=http://ec2-50-112-66-228.us-west-2.compute.amazonaws.com:1337/instagram" \
https://api.instagram.com/v1/subscriptions/

curl -F "client_id=6bd3b25920394891bcd71b933ee948cc" \
     -F "client_secret=2782e585026f4371bb8e47bcf5079926" \
     -F 'object=tag' \
     -F 'aspect=media' \
     -F 'object_id=instrumentoutpost' \
     -F "callback_url=http://ec2-50-112-66-228.us-west-2.compute.amazonaws.com:1337/instagram" \
https://api.instagram.com/v1/subscriptions/