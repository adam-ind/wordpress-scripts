#!/bin/bash

export $(egrep -v '^#' hosts/$1 | xargs)
CUR_USER=`git config user.name`
LOCK_PATH="${SITE_PATH}/src/_db.lock"

echo "Attempting to unlock db on $1 using $LOCK_PATH"

ssh -T $SSH_USER@$SSH_HOST -i $SSH_KEY "test -f $LOCK_PATH && grep -Fxq \"$CUR_USER\" $LOCK_PATH && rm -f $LOCK_PATH"
if [ $? -eq 0 ]; then
  echo "$1 db is now unlocked using $CUR_USER"
  exit 0
fi

echo "ERROR: $1 is not locked by $CUR_USER, nothing to unlock"
exit 1
