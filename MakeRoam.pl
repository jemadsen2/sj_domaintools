#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          Process_Host_Table.pl
#   Author:             Jens Madsen
#
#   Revision history:
#      2016/12/31  Jens Madsen
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
# 	$Log: Process_Host_Table.pl,v $
#
#+********************************************************************************
use English;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Conf;

#
# Configure this run of the tool
#
$main::Conf = Conf->new();
#
#Define Variables
#
# my %iptable;
# my %hosttable;
# #my $date = "20170825";
my $date = `date "+%Y%m%d-%H:%M"`;
#
#
# Process Host Table
#
my ($hostname,
    $dnsname,
    $ipaddress,
#    $description,
    );
my @roam_range = split (/[\t\s]+/, $main::Conf->get_roam_range);
#$description= "Roam address";
#
#  Write A Records
$FORMAT_NAME = "ARECORDS";
$FORMAT_LINES_PER_PAGE = 500;
my $filename = $main::Conf->get_dns_dir ."/" . $main::Conf->get_domain . ".roam.inc";
print "Filename: $filename\n";
open (ARECORDS, "> $filename") or die "Can't open up $filename: $ERRNO\n";

$FORMAT_NAME = "PTRRECORDS";
$FORMAT_LINES_PER_PAGE = 500;
$filename = $main::Conf->get_dns_dir ."/" . $main::Conf->get_network . ".roam.inc";
print "Filename: $filename\n";
open (PTRRECORDS, "> $filename") or die "Can't open $filename: $ERRNO\n";

for $ipaddress (61..92){
    $hostname = "roam-$ipaddress";
    $dnsname = "$hostname.mydomain.local";
    write ARECORDS;
    write PTRRECORDS;
}


close (ARECORDS);
close (PTRRECORDS);
exit;
#
# Write PTR (rev) Records
$FORMAT_NAME = "PTRRECORDS";
$FORMAT_LINES_PER_PAGE = 500;
$filename = $main::Conf->get_dns_dir ."/" . $main::Conf->get_network . ".roam.inc";
print "Filename: $filename\n";
open (PTRRECORDS, "> $filename") or die "Can't open $filename: $ERRNO\n";
for $ipaddress ($roam_range[0]..$roam_range[1]){
    $hostname = "roam-$ipaddress";
    $dnsname = "$hostname.mydomain.local";
    write PTRRECORDS;
}
close (PTRRECORDS);
exit;
#
#
#
#
exit;


$FORMAT_NAME = "ARECORDS";
$FORMAT_LINES_PER_PAGE = 500;
ARECORDS->format_lines_per_page(500);
sub Awriterecord {
    $hostname = $ARG[0];
    $ipaddress = $ARG[1];
    #$description = $ARG[2];
    #print "DNS_A $hostname, $ipaddress, $description\n";
     
    write ARECORDS;
}

sub Aopenfile {
    $date = $ARG[0];
    open (ARECORDS, ">$main::parms{'domain'}") or die "Can't open up $$main::parms{'domain'}.inc: $ERRNO\n";
}

sub Aclosefile {
    close (ARECORDS);
}

format ARECORDS_TOP =
; ==========================================================
; Start of Domain A Records - Origin is @*
                    $main::Conf->get_domain
; As of @*
     $main::Conf->get_date
; ==========================================================
;
.
    
format ARECORDS =
@<<<<<<<<<<<<<<< IN  A  10.20.30.@*
$hostname,                        $ipaddress
.


$FORMAT_NAME = "PTRRECORDS";
$FORMAT_LINES_PER_PAGE = 500;
PTRRECORDS->format_lines_per_page(500);
sub writerecord {
     $hostname = $ARG[0];
     $ipaddress = $ARG[1];
     #$description = $ARG[2];
     #print "DNS_PTR: $hostname, $ipaddress, $description\n";
     
     write PTRRECORDS;
     }

sub openfile {
    $date = $ARG[0];
    my ($fname, @elms);
    @elms = split ("[.]", $main::parms{'network'});
    $fname = "$elms[2].$elms[1].$elms[0].rev";
    #print "DNS PTR Opening Filename: $fname\n";
    open (PTRRECORDS, ">$fname") or die "Can't open up $fname $ERRNO\n";
    #write PTRRECORDS_TOP;
}

sub closefile {
    #write PTRRECORDS_BOTTOM;
    #print "Closing DNS PTR\n";
    close (PTRRECORDS);
}

format PTRRECORDS_TOP =
; ==========================================================
; Start of Domain PTR Records - Origin is @*
                    $main::Conf->get_network
; As of @*
     $main::Conf->get_date
; ==========================================================
;
.

format PTRRECORDS =
@<<<<<<< IN  PTR  @*.
$ipaddress,       $dnsname,$main::parms{'domain'}
.
