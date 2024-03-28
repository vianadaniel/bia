#!/bin/bash
versao=$(git rev-parse HEAD | cut -c 1-7)
echo TAG=$versao >> .env

docker compose -f docker-compose.yml config --no-normalize >> docker-compose-dev.yml

sed -i '' '/^name:/d' docker-compose-dev.yml
sed -i '' 's/^.*context.*$/     context: ./' docker-compose-dev.yml

mv docker-compose-dev.yml docker-compose.yml
