#!/bin/bash

# démarrer ngrok en arrière-plan
nohup /snap/bin/ngrok http 8080 > /tmp/ngrok.log 2>&1 &

# attendre démarrage
sleep 5

# récupérer URL
URL=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')

echo "NGROK URL: $URL"
