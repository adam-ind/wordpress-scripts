# Wordpress Scripts
Scripts for managing remote wordpress installations.

## What you need
These scripts assume a lot about the systems you're using, so it is encouraged to copy and customize these scripts for each project. It also assumes the use of .env files for setting up environment variables, and some **magic paths** and commands (such as my usage of ``vagrant ssh`` on my local machine) that you almost certainly want to change. These were created for my use and evolve with my needs, so they probably will do the same for you.

## Folder structure
* ``src`` contains your wordpress install
* ``bin`` contains the bash scripts
* ``hosts`` contain configuration for accessing remote hosts

## Usage
There are two main scripts to use: ``bin/database.sh`` and ``bin/uploads.sh``. Each have similar syntax:
```
$ bin/script.sh <environment> <mode>
```
* \<environment\> is a filename in your ``hosts/`` folder.
* \<mode\> is one of a series of commands: push, pull, backup, lock, and unlock.
  
  * push: Take whatever you have locally and push it to the remote host
  * pull: The opposite, pull the data from the remote host and put it on your local machine
  * backup: Only usable with ``database.sh``, creates a db.sql.gz for easy backup of a db
  * lock/unlock: Only usable with `database.sh`, puts a lock file on the remote machine to prevent two people from overwriting the database at the same time. You probably will never have to use this.
  
## Workflow
When setting up a wordpress staging env, you typically will want to initialize it with a "push" instead of setting it up from scratch. Simply edit your hosts/staging.env file with the correct credentials, then push your local dev database and uploads to initialize it:

```
$ bin/database.sh staging.env push
...
When done:
$ bin/uploads.sh staging.env push
```

Once set up, you will typically do "pulls" often from staging or production to your local machine:
```
$ bin/database.sh staging.env pull
```
This will overwrite everything local and keep your dev env in sync with staging or prod.

If you have uploaded some images to staging and wish to get those on your local machine as well, simply do the same with the uploads script. This may take a lot longer depending on your image sizes, number of images, etc.

```
$ bin/uploads.sh staging.env pull
```

### Known issues
* These scripts can be a bit fragile and don't have proper error handling for all edge cases, such as a network disruption.
* Some wordpress widgets store their state as a serialized array, which is not properly handled by the simple grep to convert hostnames between hosts. These widgets will appear broken but it will not interfere with the rest of the site.
