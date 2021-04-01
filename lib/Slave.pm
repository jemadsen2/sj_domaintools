#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          Slave.pm
#   Author:             Jens Madsen
#
#   Revision history:
#      2016/12/30  Jens Madsen
#                  Initial Revision
#
#   Description:
#       TBD.
#
#   Assumptions:
#       TBD.
#
#   Implicit Inputs:
#       TBD.
#
#   Inputs:
#       TBD.
#
#   Outputs:
#       TBD.
#
#   Notes:
#       TBD.
#
#   Implementation:
#
#   Future Plans:
#
#   Related Documentation:
#       TBD.
#
#+********************************************************************************
package Slave;
use strict;
use English;
our $sitename;
our $nsip;
our $description;
our $domain;

$FORMAT_NAME = "SRECORDS";
$FORMAT_LINES_PER_PAGE = 500;
SRECORDS->format_lines_per_page(500);

sub writezone {
    $sitename = shift @ARG;
    $nsip = shift @ARG;
     
    my $path = File::Spec->catfile ($main::Conf->get_var_etc, $sitename);
    print "Zone Path: $path\n";
    open (SRECORDS, ">" . $path) or die "Can't open up $path $ERRNO\n";
    close (SRECORDS);
}

format MRECORDS_TOP =
//
// master nameserver config for @* as of @*
      $sitename, $main::Conf->get_date
//
zone "@*" IN {
       	$sitename
        type master;
        file "@*";
       	$mydomain_path
        allow-update { none; };
        //
        // IP addresses of slave servers allowed
        allow-transfer {
	  @*.0/24;
	$main::Conf->get_network
	  localhost;
       }
};
.

format SRECORDS_TOP =
//
// slave nameserver config for @* as of @*
      $sitename, $main::Conf->get_date
//
zone "@*" IN {
       $sitename
        type slave;
        file "slaves/@*";
       $sitename
        masters { @*; };
       $nsip
};
.

1
