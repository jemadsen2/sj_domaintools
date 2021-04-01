#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          Named.pm
#   Author:             Jens Madsen
#
#   Revision history:
#      2021/02/16  Jens Madsen
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
package Named;
use strict;
use English;
#our $hostname;
#our $ipaddress;
#our $description;
#our $domain;
#our $date;
my $path;
my $mydomain_path;
my $sitename;
my $nsip;

sub writezone {
    $sitename = shift @ARG;
    $nsip = shift @ARG;
    #
    # Master named file
    #
    $FORMAT_NAME = "MRECORDS";
    $FORMAT_LINES_PER_PAGE = 500;
    MRECORDS->format_lines_per_page(500);

    $mydomain_path = File::Spec->catfile ($main::Conf->get_mydomain_path, $sitename);
    $path = File::Spec->catfile ($main::Conf->get_var_etc, "master", $sitename);
    print "Master_A Path: $path, $mydomain_path\n";
    open (MRECORDS, ">" . $path) or die "Can't open up $path $ERRNO\n";
    write MRECORDS;
    close (MRECORDS);
    #
    # Slave named file
    #
    $FORMAT_NAME = "SRECORDS";
    $FORMAT_LINES_PER_PAGE = 500;
    SRECORDS->format_lines_per_page(500);

    my $path = File::Spec->catfile ($main::Conf->get_var_etc, "slave", $sitename);
    print "Zone Path: $path\n";
    open (SRECORDS, ">" . $path) or die "Can't open up $path $ERRNO\n";
    write SRECORDS;
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

format MRECORDS =
;@||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
"End of list"
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

format SRECORDS =
;@||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
"End of list"
.
   
1
