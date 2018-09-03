#!/bin/perl

use strict;
use warnings;
use 5.010;

# get sections and items to match against
open(my $ini_fd, "<", "sections.ini") or die "couldn't read ini";

# get data
open(my $data_fd, "<", "test.csv")    or die "couldn't read data";
my @data = <$data_fd>;

# init data structures
my %data_struct = ();
my $current_section = "Data";

foreach (<$ini_fd>) {

  # match
  given($_) {
  
    # if line empty
    when(/\S/) {
      next;
    }

    # if section header
    when(/\[(.*)\]/)  {

      # add to hash
      $data_struct{$1} = [];

      # set current section
      $current_section = $1;
    }
    
    # if item that is to be matched
    when(/(.+)/)      {
      my $item = $1;

      # get rid of potential newlines, cause that screws everything up!
      $item =~ s/\n//;
      $item =~ s/\r//;

      # match data against item
      foreach (@data) {
        given($_) {

          # if item is found in the data
          when(/$item+/) {
            # append to file structure
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

foreach (keys %data_struct) {

  # create file
  open(my $output_fd, ">>", "$_.csv")   or die "couldn't open output file $_.csv";

  # print output to file
  foreach (@{ $data_struct{$_} }) {
          print $output_fd "$_\n";
  }

  # close fd
  close $output_fd  or die "couldn't close output fd";
}

close $ini_fd       or die "couldn't close fd";
close $data_fd      or die "couldn't close fd";
