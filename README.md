# mastodon-backup: Backup your essential Mastodon files using rsync!

A small package to of scripts and a cronjob to create rsync backups for your mastodon instance.

This set of scripts was created to automate some of the basic maintenance that I would normally use to cleanup and make backups of my mastodon instance, based on [HasHooves' version for S3](https://github.com/HasHooves/mastodon-backup).

## Prerequisites

These scripts assume that you have access to an rsync-enabled account, with snapshots enabled.

As such, the files will not be timestamped or rotated - they will just be periodically copied to the destination. You can browse your snapshots to recover from an earlier point in time.

## Install these scripts

On your Mastodon server, log on and move to `/opt` (or your preferred location) and clone this repo

```bash
sudo su
cd /opt
git clone https://github.com/kurucu/mastodon-backup.git
cd mastodon-backup
```

## Configure the credentials and details

- Install rsync on the server, if you don't already have it
- Place a copy of your Mastodon instance root _public_ key in `~/.ssh/authorized_keys` on the rsync server
- Copy `example_config.sh` to `config/config.sh`, and then fill it out with your details

```bash
cp example_config.sh config/config.sh
nano config/config.sh
```

Update, as a minimum, the `rsync_destination` variable, and then press `ctrl-o` to save and `ctrl-x` to exit.

## Prepare the script files

- Set the two files as executable:

```bash
chmod +x backup.sh
chmod +x config/config.sh
```

## Cronjobs

### Setting up automated backups

Add this line to the crontab for your `root` user, to run the backup daily and to generate a log.

The `3` is for 3am - assuming the time on your server is UTC, you may want to adjust this for where you are. For example, mine runs at 17 (i.e. 5pm), which is around 3am in Australia/Melbourne, depending on the time of year.

```bash
0 3 * * * /opt/mastodon-backup/backup.sh > /opt/mastodon-backup/logs/backup.log 2>&1
```

This, optional one, restarts your server weekly.

```bash
0 0 * * 0 /sbin/shutdown -r now
```

### Automatic media cleanup

If you have followed the [mastodon installation instructions](https://docs.joinmastodon.org/admin/setup/#cleanup), you have two cron jobs running already. One removes old media, and the other removes old preview cards.

Ensure these are installed now.

### Restart Cron

- After making changes to crontab, restart the cron service:

```bash
sudo service cron restart
```
