#!/bin/bash

export $(egrep -v '^#' hosts/$1 | xargs)
UPLOADS_DIR=src/web/app/uploads/
REMOTE=$SSH_USER@$SSH_HOST:${SITE_PATH}/${UPLOADS_DIR}

echo "Getting uploads/ from $1..."

# -r recursive
# -v verbose
# -a archive (-rlptgoD)
# -z compress
# -P partial progress
rsync -zaP -e "ssh -i $SSH_KEY" $REMOTE $UPLOADS_DIR

echo "Local uploads/ updated from $1."
