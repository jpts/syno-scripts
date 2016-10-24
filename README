# Synology Utility Scripts

A repository for scripts I use on my Synology NAS  

All tested under the current stable version of DSM 6  

## Dependencies

media-indexer.pl and find-orphans.pl require perl, which can be installed through the DSM package center

Both also use Logging::Simple module, which can be downloaded from [metacpan](https://api.metacpan.org/source/STEVEB/Logging-Simple-1.01/lib/Logging/Simple.pm) or [github](https://github.com/stevieb9/p5-logging-simple). Should be placed in the 'Logging' sub-folder.

## Media Indexer

This script scans for recently changed video files and adds them to the synology media database.  

It's arguments are folders to scan. Eg: 
```
/path/to/media-indexer.pl /media/tv1/ /media/tv2/
```

NB: all checks are based on the filename, and assume it is unique.

Features:
  * Removes duplicate index entries
  * Removes orphaned index entries
  * Will correct index entries if the filepath has changed, attempting to preserve metadata
  * Log a warning if multiple files are found for one index

This should be set up to run regularly (daily) through cron or DSM task scheduler.  


## Find Orphans

This script compares checks all files in the synology index actually exist. 

Pass the -r argument to delet orphans.  

Pass the -s argument to search for specific files. Without this argument the script may take some time to run dependant on the size of your media collection.


## convert.sh

Handy script for batch trimming video files to the correct length
