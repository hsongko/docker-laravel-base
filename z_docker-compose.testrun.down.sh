#!/bin/bash
sudo docker logout \
\
&& sudo docker-compose \
  --env-file .env.development \
  -f docker-compose.testrun.yml down
