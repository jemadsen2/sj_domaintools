#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          DNS_A.pm
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
package DNS_A;
use strict;
use English;
our $hostname;
our $ipaddress;
our $description;
our $domain;
our $date;
our $sname;
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
    
    my $path = File::Spec->catfile ($main::Conf->get_dns_dir, $main::Conf->get_domain);
    #print "DNS_A Path: $path\n";
    open (ARECORDS, ">" . $path) or die "Can't open up $path $ERRNO\n";

    my $header = << "END_HEADER";
; ==========================================================
; Start of Domain $domain A Records as of $date
; ==========================================================
; File:   /var/named/mydomains/$domain
;
; \$ORIGIN $domain
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

my $servers = << "END_SERVERS";
;
;Include Servers
\$INCLUDE /var/named/chroot/var/named/mydomains/$domain.servers.inc
;
;Include Roaming hosts
\$INCLUDE /var/named/chroot/var/named/mydomains/$domain.roam.inc
;
END_SERVERS
    
    print ARECORDS $header;

    foreach my $ns (@ns) {
my $ns_record = << "END_NS_RECORD";
		IN	NS	$ns.$domain.		; Internet address of Name Server
END_NS_RECORD

    print ARECORDS $ns_record;
    }
    
    foreach my $mspair (@ms) {
	#print "ms pair: $mspair\n";
	my ($ms, $priority) = split (/\s*[:]\s*/, $mspair);
	#print "MS: $ms; priority: $priority; pair: $mspair\n";

	my $ms_record = << "END_MS_RECORD";
		IN	MX	$priority   $ms.$domain.
END_MS_RECORD
	
	print ARECORDS $ms_record;
    }
    print ARECORDS $servers;
}


sub writerecord {
    $hostname = sprintf '%-16s', $ARG[0];
    $ipaddress = $ARG[1];
    $description = $ARG[2];
    chomp $description;
    chop $description;
    #print "DNS_A $hostname, $ipaddress, $description, $sname\n";
     
my $arecord = << "END_ARECORD";
;
; $description
$hostname IN    A  $network.$ipaddress
END_ARECORD

    print ARECORDS $arecord;
}


sub closefile {
    close (ARECORDS);
}

1

