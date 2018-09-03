#!/bin/perl

use warnings;
use strict;

open(my $in, "<", "input.txt")		or die "failed to read input.txt\n";
open(my $sec, "<", "sec.txt")		or die "failed to read sec.txt\n";

my @data = <$in>;
# my $secs = <$sec>;

while (<$sec>) {

  my $item = $_;
  $item =~ s/\n//;
  $item =~ s/\r//;

  foreach (@data) {
    $_ =~ s/\n//;
  
    my $match = "";
  
  
    if ($_ =~ m/$item/) {
      $match="!"
    }
  
    print "$_	$match\n";
  }

}
