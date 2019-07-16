#!/bin/bash


export $(egrep -v '^#' src/.env | xargs)

export $(egrep -v '^#' hosts/$1 | xargs)
echo "Getting db from $1"
{
ssh -Tq $SSH_USER@$SSH_HOST -i $SSH_KEY /bin/bash << EOF
cd "${SITE_PATH}"
export \$(egrep -v '^#' src/.env | xargs)
mysqldump -u\$DB_USER -p\$DB_PASSWORD \$DB_NAME |
 sed -e "s~\${WP_HOME}~${WP_HOME}~g" |
 gzip -f
exit 0
EOF
} > _db.sql.gz


echo "Importing to $DB_NAME"
vagrant ssh -c "gzip -dc /vagrant/_db.sql.gz | mysql -u'$DB_USER' -p'$DB_PASSWORD' $DB_NAME"

echo "local db is now from $1"
