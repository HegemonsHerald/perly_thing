#!/bin/perl

use strict;
use warnings;
use 5.010;

# my $data = "match me baby wheee heh ehe heheheh heh eh eheheheeheh";
# my $data2 = "match me as well baby hahah thisthl";
# my $patty = "baby wheee heh";
# my @arr = ($data, $data2);
# my @pat = ($patty);
# 
# foreach (@pat) {
#   my $pattern = $_;
#   foreach (@arr) {
#     given ($_) {
#       when (/(.*$pattern.*)/) { print "matched\n"; print "$1\n" }
#       default { print "didn't match\n"; print "$_\n" }
#     }
#   }
# }

# You'll also need a test for '[]'


# 0. for some reason, matching against lines doesn't work anymore!
# 0.1 take out the empty line statement and check what happens then!
# 0.2 try to find out, why that might make the other wheres behave differently
# 1. in s.pl read from a file, so you got the buffer-line input
# 2. match against that
# 3. match with commas, match with \"s, match with \'s
# ...?

open(my $ini_fd, "<", "sections.ini") or die "couldn't read ini";
open(my $data_fd, "<", "test.csv")    or die "couldn't read data";
my @data = <$data_fd>;

while (<$ini_fd>) {
  given($_) {
    when(/^$/) {
      next;
    }
    when(/\[(.*)\]/) {
      print "oooh, section!\n";
    }
    when(/(.+)/) {
      
      my $item = $1;
      $item =~ s/\n//;
      $item =~ s/\r//;

      foreach (@data) {
        
        # THE INDEX() SOLUTION
        # my $pos = index $_, $item;
        # if ( $pos != -1 ) {
        #   print "$_";
        # }

        # THE GIVEN-REGEX SOLUTION
        # Note, that apparently regex match against parts of lines → grep-esque behaviour
        given($_) {
          when(/$item/) {
            print "$_";
          }
          default {}
        }
      }
    }
  }
}
