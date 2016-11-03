#!/bin/perl


# Inspired by http://www.naschenweng.info/2010/02/13/synology-automatic-indexing-via-synoindex/
# Must be run as root, for log and db access

# Currently only proccesses video

use strict;
use warnings;

use lib qw(/volume1/system/syno-scripts/);
use Logging::Simple;

my $log = Logging::Simple->new(name => 'MediaIndexer', file => '/var/log/media-scripts.log', level => 6);

my @include_files = ("avi","m4v","mkv","mov","mp4","mpeg4","vob","mpg",);

if (!@ARGV) {
	$log->warning("No scanning directory passed.");
	exit(1);
}

my @files;
foreach my $dir (@ARGV)
{
	my @out = `find "$dir" -type f -ctime -3 | egrep -i -v '(sample|extras|sparse_files)'`;
	push(@files,@out);
}
my $files_indexed = 0;

foreach (@files) {
	my $file = $_;
	chomp($file);
	my $ext = ($file =~ m/([^.]+)$/)[0];
	my $title = ($file =~ m/([^\/]+)\..+$/)[0];

	if (grep {lc $_ eq lc $ext} @include_files)
	{
		$log->debug("$title.$ext");
		$title =~ s/\'/\\\'/g; ## escape single quotes in filename
		my @paths = `psql mediaserver postgres -tA -c "select path from video where path like '%$title.$ext'";`;
		my $count = @paths;
		$log->debug("Count: $count");

		#check for orphans first
		if ($count >= 2)
		{
			foreach my $path (@paths)
			{
				chomp($path);
				if (!-f $path)
				{
					$log->info("Deleted orphan: $path");
			        `synoindex -d \"$path\"`;
					$count--;
				}
			}
		}

		if ($count == 0)
		{
			$log->info("Adding file to index: $file");
			`synoindex -a \"$file\"`;
			++$files_indexed;
		}
		elsif ($count == 1)
		{
			chomp($paths[0]);
			if ($paths[0] eq $file)
			{
				$log->info("File already indexed: $file");
			}
			else
			{
				$log->info("File reindexed to: $file");
				`synoindex -n \"$file\" \"$paths[0]\"`; 
				++$files_indexed;
			}
		}
		else
		{
			$log->warn("Duplicates detected for $file");
		}

	}
}

if ($files_indexed)
{
	$log->info("Synology Media Indexer added $files_indexed new media file(s)");
}
else
{
	$log->info("Synology Media Indexer did not find any new media in @ARGV.");
}

