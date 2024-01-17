#!/bin/sh
set -ex
BACKUP_POINT=${1:-LATEST}

# Move configuration to tempory location during cleanup
mv $PGDATA/*.conf /tmp
rm -rf $PGDATA/*

# Fetch latest backup and change it for anything you like
wal-g backup-fetch $PGDATA $BACKUP_POINT 

# Move to config back again
mv /tmp/*.conf $PGDATA/

# Disable Archive mode if enabled, and enable restore
sed -i -e 's/^archive_mode\s*=\s*on/archive_mode = off/' $PGDATA/postgresql.conf
sed -i -e "s/^#restore_command = ''/restore_command = 'wal-g wal-fetch %f %p'/" $PGDATA/postgresql.conf
touch $PGDATA/recovery.signal

cat <<EOF
***************************************************************************
* The database is started in recovery mode and wal-g segements are replayed
* When database is ready to accept connection and recovery is done, hit ^C
* 
* Start a new container to start in Normal mode
***************************************************************************
EOF
# Start DB and let it Go !
exec docker-entrypoint.sh postgres
