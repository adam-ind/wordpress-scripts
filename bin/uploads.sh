#!/bin/bash
shopt -s nullglob

# get all .env vars into this shell
export $(egrep -v '^#' src/.env | xargs)

UPLOADS_PULL_CMD="./bin/pull-uploads.sh $1"
UPLOADS_PUSH_CMD="./bin/push-uploads.sh $1"
ENVIRONMENTS=( hosts/* )
ENVIRONMENTS=( "${ENVIRONMENTS[@]##*/}" )
NUM_ARGS=2

show_usage() {
  echo "Usage: bin/uploads.sh <environment> <mode>

<environment> is the environment to sync uploads ("staging.env", "production.env", etc)
<mode> is the sync mode ("push", "pull")

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  ./bin/uploads.sh staging.env push
  ./bin/uploads.sh staging.env pull
  ./bin/uploads.sh production.env push
  ./bin/uploads.sh production.env pull
"
}

HOSTS_FILE="hosts/$1"

[[ $# -ne $NUM_ARGS || $1 = -h ]] && { show_usage; exit 0; }

if [[ ! -e $HOSTS_FILE ]]; then
  echo "Error: $1 is not a valid environment ($HOSTS_FILE does not exist)."
  echo
  echo "Available environments:"
  ( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )
  exit 0
fi

case $2 in
  push)
    $UPLOADS_PUSH_CMD
  ;;
  pull)
    $UPLOADS_PULL_CMD
  ;;
  *)
    show_usage
  ;;
esac
