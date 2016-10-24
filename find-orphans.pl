#!/bin/perl
# Adapted from http://wacha.ch/wiki/synology

use strict;
use warnings;

use lib qw(/volume1/system/scripts/index/);
use Logging::Simple;

my $log = Logging::Simple->new(name => 'FindOrphans', file => '/var/log/media-scripts.log', level => 7);                                                                                  

my $del=0;
my $path = '';
my @dbs = ('video','music','photo');
my $count = 0;

while (my $arg = shift)
{
  if ($arg eq "-r") { $del=1 } elsif ($arg eq "-s") { $path=shift };
}
 

foreach my $db (@dbs)
{
  my @files = `psql mediaserver postgres -tA -c "select path from $db where path like '%$path%'\;"`;
  foreach my $file (@files)
  {
    chomp($file);
    if (!-f $file)
    {
      if($del)
      {
        $log->info("Deleted orphan: $file");
        `synoindex -d \"$file\"`;
      }
      else
      {
        $log->info("Found orphan, not deleting: $file");
      }
      $count++;
    }
  }
}

if ($count) {$log->info("Processed $count orphans.");}
