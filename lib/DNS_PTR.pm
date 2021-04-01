#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          DNS_PTR.pm
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
package DNS_PTR;
use strict;
use English;
our $hostname;
our $ipaddress;
our $description;
our $domain;
our $date;
our ($fname, @elms);
our $path;
our $rev;
#our $inc;
our $mail_admin;
our $serial;
our $network;
our @ns;
our @ms;

sub openfile {
    $domain = $main::Conf->get_domain;
    $date = $main::Conf->get_date;
    $mail_admin = $main::Conf->get_mail_admin;
    $serial = $main::Conf->get_serial;
    $network = $main::Conf->get_network;
    @ns = split (/\s*[,]\s*/, $main::Conf->get_nameservers);
    @ms = split (/\s*[,]\s*/, $main::Conf->get_mailservers);
    #our $inc = "$main::Conf->get_network.rev.inc";
    
    @elms = split ("[.]", $main::Conf->get_network);
    $fname = "$elms[2].$elms[1].$elms[0].rev";
    $rev = "$elms[2].$elms[1].$elms[0]";
    $path = File::Spec->catfile ($main::Conf->get_dns_dir, $fname);
    #print "DNS_PTR Path: $path\n";
    #print "DNS PTR Opening Filename: $path\n";
    open (PTRRECORDS, ">$path") or die "Can't open up $path $ERRNO\n";


    my $header = << "END_HEADER";
; ==========================================================
; Start of Domain $domain PTR Records as of $date
; ==========================================================
; File:   /var/named/mydomains/$rev.rev
;
;\$ORIGIN $rev.in-addr.arpa.
\$TTL 1D
@		IN	SOA $ns[0].$domain. $mail_admin. (
                                $serial      ; serial
                                6H              ; Refresh
                                1H              ; Retry
                                1W              ; Expire
                                1D              ; Minimum TTL
                                )
;
END_HEADER

    print PTRRECORDS $header;
    #
    # Add Name Servers
    #
    foreach my $ns (@ns) {

	my $ns_record = << "END_NS_RECORD";
		IN	NS	$ns.$domain.		; Internet address of Name Server
END_NS_RECORD

	print PTRRECORDS $ns_record;
    }
    #
    # Add Roaming Hosts
    #
    my $roaming_hosts = << "END_ROAM_HOSTS";
;
;Include Roaming hosts
\$INCLUDE /var/named/chroot/var/named/mydomains/$rev.rev.roam.inc
;
END_ROAM_HOSTS

    print PTRRECORDS $roaming_hosts;
}

sub writerecord {
    $hostname = shift @ARG;
    $ipaddress = sprintf '%-3s', shift @ARG;
    $description = shift @ARG;
    chomp $description;
    chop $description;
    
    #  190      IN  PTR  ph-spa3102.madnet.madcyberspace.com.

    my $arecord = << "END_ARECORD";
;
; $description
$ipaddress IN  PTR  $hostname.$domain.
END_ARECORD

    print PTRRECORDS $arecord;
}


sub closefile {
    #write PTRRECORDS_BOTTOM;
    #print "Closing DNS PTR\n";
    close (PTRRECORDS);
}


1
