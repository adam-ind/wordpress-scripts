#!/bin/bash


export $(egrep -v '^#' hosts/$1 | xargs)
CUR_USER=`git config user.name`
LOCK_PATH="${SITE_PATH}/src/_db.lock"

echo "Attempting to lock db on $1 using $LOCK_PATH"

ssh -T $SSH_USER@$SSH_HOST -i $SSH_KEY "( ! test -f $LOCK_PATH || [[ \""$CUR_USER"\" == "\$\(cat $LOCK_PATH\)" ]] ) && echo "$CUR_USER" > $LOCK_PATH"
if [ $? -eq 0 ]; then
  echo "$1 db is locked using $CUR_USER"
  exit 0
fi

echo "ERROR: Could not lock $1"
exit 1
