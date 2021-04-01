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

#use write_report;
use DNS_A;
use DNS_PTR;
use DHCP;
#
# Define Tables
#
my %iptable;
my %hosttable;

my $date = `date "+%Y%m%d-%H:%M"`;
#
# Configure this run of the tool
#
$main::Conf = Conf->new();
#
# Process Host Table
#
#my ($hostname, $MACaddress, $Location, $ipaddress, $Use, $SystemType, $LookupName, $description, $OperatingSystem1, $SerialNumber, $OperatingSystem2);
#
# Local variables
#
my (@lines, $line);
#
# Get Host Table and create hostname hash and IPhash
#
print "Main: ", $main::Conf->get_hosttable, "\n";
open (HOSTTABLE, $main::Conf->get_hosttable) || die "Can't open ", $main::Conf->get_hosttable, " $ERRNO\n";
#
@lines = <HOSTTABLE>;
close (HOSTTABLE);
#print @lines;
#
# Process each line of the Host Table
#
my $firstLineFlag = 1;
foreach $line (@lines) {
    if ($firstLineFlag) {
	$firstLineFlag =0;
	next;
    }
    print "$line";
    chomp $line;
    my ($hostname, $MACaddress,  $ipaddress, $allocation, $description) = 
	split ("\t", $line);
    if ($ipaddress ne "" and $MACaddress ne "") {	
	#print "$hostname, $MACaddress,  $ipaddress, $allocation, $description\n";
	$iptable{$ipaddress}[0] = $hostname;
	$iptable{$ipaddress}[1] = $ipaddress;
	$iptable{$ipaddress}[2] = $MACaddress;
	$iptable{$ipaddress}[3] = $description;
	
	$hosttable{$hostname}[0] = $hostname;
	$hosttable{$hostname}[1] = $ipaddress;
	$hosttable{$hostname}[2] = $MACaddress;
	$hosttable{$hostname}[3] = $description;
    }
}
&DNS_A::openfile ($date);
#my $host;
foreach my $host (sort keys %hosttable){
#	#print "$host $hosttable{$host}[0] $hosttable{$host}[2]\n";
    &DNS_A::writerecord ($hosttable{$host}[0], $hosttable{$host}[1], $hosttable{$host}[3]);
}
&DNS_A::closefile ();
#
#
&DNS_PTR::openfile ($date);
#my $ip;
foreach my $ip (sort { $a <=> $b } keys %iptable){
    #print "$ip $iptable{$ip}[0] $iptable{$ip}[2]\n";
    &DNS_PTR::writerecord ($iptable{$ip}[0], $iptable{$ip}[1], $iptable{$ip}[3]);
}
&DNS_PTR::closefile ();
#
#
&DHCP::openfile ($date);
#my $ip;
foreach my $host (sort keys %hosttable){
    &DHCP::writerecord ($hosttable{$host}[0], $hosttable{$host}[1], $hosttable{$host}[2],
			$hosttable{$host}[3]);
}
&DHCP::closefile ();
#
#
exit;
