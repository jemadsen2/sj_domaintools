#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          MakeExternal.pl
#   Author:             Jens Madsen
#
#   Revision history:
#      2021/01/27  Jens Madsen
#                  Initial Revision
# 
#   Description:
#       Program to build External Sites.
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
#
use English;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Conf;

#use write_report;
use External;
use Named;
#use Slave;
use WebList;
#
# Define Tables
#
#
# Configure this run of the tool
#
$main::Conf = Conf->new();
#
# Local variables
#
my (@lines, $line);
#
# Get Host Table and create hostname hash and IPhash
#
print "Main: ", $main::Conf->get_sitelist, "\n";
open (WEBSITES, $main::Conf->get_sitelist) || die "Can't open ", $main::Conf->get_sitelist, " $ERRNO\n";
#
@lines = <WEBSITES>;
close (WEBSITES);
#print @lines;
#
# Process each line of the Host Table
#
&WebList::openfile ();

foreach $line (@lines) {
    #print "1 $line";
    if ($line !~ / \S /x ) {next;}
    #print "2 $line";
    if ($line =~ /^ \s* \#/x ) {next;}
    # if ($firstLineFlag) {
    # 	$firstLineFlag =0;
    # 	next;
    # }
    print "$line";
    chomp $line;
    &WebList::writerecord ($line);

}
&WebList::closefile ();
exit;
