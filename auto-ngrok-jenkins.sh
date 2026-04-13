#!/bin/bash

# 1. start ngrok
nohup /snap/bin/ngrok http 8080 > /tmp/ngrok.log 2>&1 &

sleep 5

# 2. get ngrok url
URL=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')

echo "NEW URL: $URL"

# 3. update GitHub webhook
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN " \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/kaloujonathan/devops-project/hooks/605890880 \
  -d "{\"config\":{\"url\":\"$URL/github-webhook/\"}}"
