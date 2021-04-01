#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          DHCP.pm
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
#   CVS History:
#
#+********************************************************************************
package DHCP;
use strict;
use English;
our $hostname;
our $ipaddress;
our $MACaddress;
our $description;
our $domain;
our $date;

$FORMAT_NAME = "DHCPRECORDS";
$FORMAT_LINES_PER_PAGE = 500;
DHCPRECORDS->format_lines_per_page(500);
sub writerecord {
    $hostname = shift @ARG;
    $ipaddress = shift @ARG;
    $MACaddress = shift @ARG;
    $description = shift @ARG;
    chomp $description;
    chop $description;
   #print "DHCP $hostname, $ipaddress, $description\n";
     
    write DHCPRECORDS;
}

sub openfile {
    $date = $ARG[0];
    my $path = File::Spec->catfile ($main::Conf->get_dhcp_dir, $main::Conf->get_domain . ".conf");
    #print "DHCP Path: $path\n";
    open (DHCPRECORDS, ">" . $path) or die "Can't open up $path $ERRNO\n";
}

sub closefile {
	print (DHCPRECORDS "}\n");
     close (DHCPRECORDS);
     }	

format DHCPRECORDS =
@
"#"
@ @*
"#", $description
@
"#"
host @<<<<<<<<<<<<<<< {
    $hostname
    hardware ethernet @*;
    $MACaddress
    fixed-address @*.@*;
    $main::Conf->get_network, $ipaddress
    }
.

format DHCPRECORDS_TOP =
@ ====================================================================
"#"
@ Start of Domain @* DHCP as of @*
"#", $main::Conf->get_domain, $date
@ ====================================================================
"#"
#
#
group {
#       default-lease-time 28800;  # 8 hours
#       max-lease-time 86400;  # 24 hours
       default-lease-time 30;  # 0.5 hours  TESTING
       max-lease-time 60;  # 1 hours  TESTING
.

1
