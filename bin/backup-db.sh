#!/bin/bash


export $(egrep -v '^#' hosts/$1 | xargs)
echo "Getting db from $1"
{
ssh -Tq $SSH_USER@$SSH_HOST -i $SSH_KEY /bin/bash << EOF
cd "${SITE_PATH}"
export \$(egrep -v '^#' src/.env | xargs)
mysqldump -u\$DB_USER -p\$DB_PASSWORD \$DB_NAME | gzip -f
exit 0
EOF
} > db.sql.gz

echo "Db from $1 is now db.sql.gz"
