#!/bin/bash

#!/bin/bash

[ ! -f .env ] || export $(grep -v '^#' .env | xargs);

required=(APP_IP APP_COOKIE)
for var in ${required[@]}; do
  [ -z "${!var}" ] && { echo "$var is empty or not set. Exiting.."; exit 1; }
done

elixir --erl "-detached" --name "ubi_nadeo_api@$APP_IP" --cookie $APP_COOKIE -S mix run --no-halt

