#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          External.pm
#   Author:             Jens Madsen
#
#   Revision history:
#      2021/02/01  Jens Madsen
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
package External;

use English;
use strict;
use warnings;

use Conf;

#our $hostname;
#our $ipaddress;
#our $description;
#our $sitename;
#our $date;

$FORMAT_NAME = "ARECORDS";
$FORMAT_LINES_PER_PAGE = 500;
ARECORDS->format_lines_per_page(500);
# sub writerecord {
#     $hostname = $ARG[0];
#     $ipaddress = $ARG[1];
#     $description = $ARG[2];
#     chop $description;
#     chop $description;
#     #print "DNS_A $hostname, $ipaddress, $description\n";
     
write ARECORDS;
#}

sub new { 
    my ($class, $args) = @ARG; 
    my $self = bless { }, $class;
#    print "End of new().";
    return bless $self;
    print "Site List (External.pm): ", $Main::Conf->get_sitelist, "\n";
}

sub openfile {
    #$date = shift @ARG;
    my $path = File::Spec->catfile ($main::Conf->get_dns_dir, $main::Conf->get_domain);
    print "DNS_A Path: $path\n";
    open (ARECORDS, ">" . $path) or die "Can't open up $path $ERRNO\n";
}

sub closefile {
    close (ARECORDS);
}

format ARECORDS_TOP =
; ==========================================================
; Start of Domain @* A Records as of @*
$main::Conf->get_sitename, $main::Conf->get_date
; ==========================================================
;	@* Zone hosts file
$main::Conf->get_sitename
;	/var/named/mydomains/@*
$main::Conf->get_sitename
;
;	  origin is @*
$main::Conf->get_sitename
;
$TTL 3D
$ORIGIN @*.
$main::Conf->get_sitename
@		IN	SOA ns1.@*. @*. (
"@",                $main::Conf->get_sitename, $main::Conf->get_mail_admin
                                @<<<<<<<<<<<    ; serial
$main::Conf->get_serial
                                8H              ; Refresh
                                2H              ; Retry
                                4W              ; Expire
                                1D              ; Minimum TTL
                                )

		IN	NS	ns1		; Internet address of Name Server
		IN	NS	ns2		; Internet address of Name Server
;
		IN	MX	10	mail2.@*.
$main::Conf->get_sitename
;		IN	MX	20	mail1.@*.
$main::Conf->get_sitename
;
; External subsite names
;
@		IN	A	@*
"@",			$main::Conf->get_serverip
ftp		IN	A	@*
			$main::Conf->get_serverip
www		IN	A	@*
			$main::Conf->get_serverip
rsync		IN	A	@*
			$main::Conf->get_serverip
imap		IN	A	@*
			$main::Conf->get_serverip
mail		IN	A	@*
			$main::Conf->get_serverip
mail1		IN	A	@*
			$main::Conf->get_serverip
mail2		IN	A	@*
			$main::Conf->get_serverip
smtp		IN	A	@*
			$main::Conf->get_serverip
ms1		IN	A	@*
			$main::Conf->get_serverip
ns1		IN	A	@*
			$main::Conf->get_ns1ip
ns2		IN	A	@*
			$main::Conf->get_ns2ip
sip		IN	A	@*
			$main::Conf->get_sipip
.
    
format ARECORDS =
;@||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
"End of list"
.
   
1
