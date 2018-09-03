#!/bin/perl

use strict;
use warnings;
use 5.010;	# for experimental given-where syntax

# get sections and items to match against
open(my $ini_fd, "<", "sections.ini") or die "couldn't read ini";

# get data (csv-files)
open(my $data_fd, "<", "test.csv")    or die "couldn't read data";
my @data = <$data_fd>;

# init data structures
my %data_struct = ();
my $current_section = "Data";

# read section file
foreach (<$ini_fd>) {

  # match line from section file
  given($_) {
  
    # if line empty
    when(/^\s*$/) {
      next;	# skip!
    }

    # if line is EMPTY section header
    when(/\[\]/)  {
      $current_section = "Data";  # empty means default
      next;	# then skip!
    }

    # if line is section header
    when(/\[(.*)\]/)  {

      # add section to hash
      $data_struct{$1} = [];

      # set current section for adding items
      $current_section = $1;
    }
    
    # if line is item, that is to be found in data
    when(/(.+)/)      {
      my $item = $1;

      # get rid of potential newlines, cause they screw up everything!
      $item =~ s/\n//g;
      $item =~ s/\r//g;

      # match data against item
      foreach (@data) {
        given($_) {

          # if item is found in the data
          when(/$item+/) {

            # append it to the section in the hash
            push @{ $data_struct{$current_section} }, $_;

          }

          # if item isn't found, do nothing
          default {}
        }
      }
    }
    default {}
  }
}


# make output file for each section in the hash
foreach (keys %data_struct) {

  # create file
  open(my $output_fd, ">>", "$_.csv")   or die "couldn't open output file $_.csv";

  # print output to file
  foreach (@{ $data_struct{$_} }) {
          print $output_fd "$_";
  }

  # close FD
  close $output_fd  or die "couldn't close output fd";
}

# clean up remaining FDs, for good measure
close $ini_fd       or die "couldn't close fd";
close $data_fd      or die "couldn't close fd";
