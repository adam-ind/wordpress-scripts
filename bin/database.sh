#!/bin/bash
shopt -s nullglob

# get all .env vars into this shell
export $(egrep -v '^#' src/.env | xargs)

DATABASE_PULL_CMD="./bin/pull-db.sh $1"
DATABASE_PUSH_CMD="./bin/push-db.sh $1"
DATABASE_BACKUP_CMD="./bin/backup-db.sh $1"
DATABASE_CLEANUP="rm -f _db.sql.gz"
DATABASE_LOCK="./bin/lock-db.sh $1"
DATABASE_UNLOCK="./bin/unlock-db.sh $1"
ENVIRONMENTS=( hosts/* )
ENVIRONMENTS=( "${ENVIRONMENTS[@]##*/}" )
NUM_ARGS=2

show_usage() {
  echo "Usage: bin/database.sh <environment> <mode>

<environment> is the environment to sync database ("staging.env", "production.env", etc)
<mode> is the sync mode ("push", "pull", "backup", "lock", "unlock")

Available environments:
`( IFS=$'\n'; echo "${ENVIRONMENTS[*]}" )`

Examples:
  ./bin/database.sh staging.env push
  ./bin/database.sh staging.env pull
  ./bin/database.sh staging.env backup
  ./bin/database.sh staging.env lock
  ./bin/database.sh staging.env unlock
  ./bin/database.sh production.env push
  ./bin/database.sh production.env pull
  ./bin/database.sh production.env backup
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
    $DATABASE_LOCK && $DATABASE_PUSH_CMD && $DATABASE_UNLOCK
    $DATABASE_CLEANUP
  ;;
  pull)
    $DATABASE_PULL_CMD
    $DATABASE_CLEANUP
  ;;
  backup)
    $DATABASE_BACKUP_CMD
  ;;
  lock)
    $DATABASE_LOCK
  ;;
  unlock)
    $DATABASE_UNLOCK
  ;;
  *)
    show_usage
  ;;
esac
