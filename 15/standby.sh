#!/bin/sh
set -ex

# Move configuration to tempory location during cleanup
mv $PGDATA/*.conf /tmp
rm -rf $PGDATA/*

# Fetch latest backup and change it for anything you like
wal-g backup-fetch $PGDATA LATEST 

# Move to config back again
mv /tmp/*.conf $PGDATA/

# Disable Archive mode if enabled, and enable restore
sed -i -e 's/^archive_mode\s*=\s*on/archive_mode = off/' $PGDATA/postgresql.conf
sed -i -e "s/^#restore_command = ''/restore_command = 'wal-g wal-fetch %f %p' | sleep 60/" $PGDATA/postgresql.conf
sed -i -e "s/^#hot_standby = on/hot_standby = on/" $PGDATA/postgresql.conf
sed -i -e "s/^#recovery_target_timeline = 'latest'/recovery_target_timeline = 'latest'/" $PGDATA/postgresql.conf
touch $PGDATA/standby.signal

cat <<EOF
***************************************************************************
* The database is started in standby mode and wal-g segements are replayed
* When wal-g logs have been replayed you can stop this container, by 
* hit ^C
* 
* Start a new container to start in Normal mode
***************************************************************************
EOF
# Start DB and let it Go !
# exec docker-entrypoint.sh postgres
