#!/bin/bash

#Get the relative path of the backup script
    tool_path=$(dirname "$realpath $0")

#Loading the Config
    source $tool_path/config/config.sh

#Stopping mastodon processes
    systemctl stop mastodon-*

#Generating a database dump backup
    su - mastodon -c "cd /home/mastodon/live && pg_dump -Fc mastodon_production > postgres.dump"

#Copying the elastic serach file
    cp /etc/elasticsearch/jvm.options $tool_path/backups/elasticsearch.jvm.options

# Copy the redis data
    cp /var/lib/redis/dump.rdb $tool_path/backups/redis.rdb

# Can start the mastodon processes again now
    systemctl start mastodon-web mastodon-sidekiq mastodon-streaming

# Copy the nginx site configuration files
    cp -r /etc/nginx/sites-available/ $tool_path/backups/sites-available

# Move the database dump file
    mv /home/mastodon/live/postgres.dump $tool_path/backups/postgres.dump

#Copy the production environment
    cp /home/mastodon/live/.env.production $tool_path/backups/.env.production

#Start the backup to rsync
    $RSYNC -avz $tool_path/backups/ $rsync_destination

#Optional - if you're not using S3 for media
#    $RSYNC -avz /home/mastodon/live/public/system $rsync_destination/public/system
