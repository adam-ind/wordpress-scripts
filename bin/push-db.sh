#!/bin/bash


export $(egrep -v '^#' src/.env | xargs)

echo "Saving local db"
vagrant ssh -c "mysqldump -u'$DB_USER' -p'$DB_PASSWORD' $DB_NAME  | gzip -f > /vagrant/_db.sql.gz"

export $(egrep -v '^#' hosts/$1 | xargs)

echo "Sending db to $1"
scp -i $SSH_KEY _db.sql.gz $SSH_USER@$SSH_HOST:${SITE_PATH}

echo "Importing db on $1"
ssh -Tq $SSH_USER@$SSH_HOST -i $SSH_KEY /bin/bash << EOF
cd "${SITE_PATH}"
export \$(egrep -v '^#' ${SITE_PATH}/src/.env | xargs)
echo "Replacing using " "s%${WP_HOME}%\${WP_HOME}%g"
gzip -dc _db.sql.gz |
 sed "s%${WP_HOME}%\${WP_HOME}%g" |
 mysql -u\$DB_USER -p\$DB_PASSWORD \$DB_NAME
rm -f _db.sql.gz
redis-cli FLUSHALL
exit 0
EOF

echo "local db is now on $1"
