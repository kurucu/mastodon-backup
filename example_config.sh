#!/bin/bash

# Update the two variables and then rename and move the file to ./config/config.sh
#use `which rsync` on the Mastodon server to find the path, if different.

RSYNC="/usr/bin/rsync"
#backup_folder_name="mastodon-backup"
rsync_destination="user@example.com:/path/to/destination"
now=$(date --iso-8601=seconds)
