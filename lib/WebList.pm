#!/usr/bin/perl -w
#-********************************************************************************
#
#   File Name:          WebList.pm
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
package WebList;
use strict;
use English;
our $website;

$FORMAT_NAME = "INCLUDES";
$FORMAT_LINES_PER_PAGE = 500;
INCLUDES->format_lines_per_page(500);
sub writerecord {
    $website = shift @ARG;
    write INCLUDES;
}

sub openfile {
    open (INCLUDES, ">" . $main::Conf->get_namedsiteinc) or
	die "Can't open up $main::Conf->get_namedsiteinc $ERRNO\n";
}

sub closefile {
    close (INCLUDES);
}

format INCLUDES_TOP =
; ==========================================================
; Include file that includes all the website includes
; Date: @*
$main::Conf->get_date
; ==========================================================
.
    
format INCLUDES =
;
include "namedsiteinc@*";
        $website
.

1
