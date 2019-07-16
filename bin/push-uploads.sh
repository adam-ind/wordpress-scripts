#!/bin/bash

export $(egrep -v '^#' hosts/$1 | xargs)
UPLOADS_DIR=src/web/app/uploads/
REMOTE=$SSH_USER@$SSH_HOST:${SITE_PATH}/${UPLOADS_DIR}

echo "Sending uploads/ to $1 using $REMOTE"

# -r recursive
# -v verbose
# -a archive (-rlptgoD)
# -z compress
# -P partial progress
rsync -zaP $UPLOADS_DIR $REMOTE 

echo "Local uploads/ are now on $1."
