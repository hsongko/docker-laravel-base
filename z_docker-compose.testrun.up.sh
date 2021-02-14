#!/bin/bash
set -o allexport; source ./.env.development; set +o allexport; \
sudo docker-compose \
  --env-file .env.development \
  -f docker-compose.testrun.yml up -d