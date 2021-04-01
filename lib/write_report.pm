#-********************************************************************************
#
#   File Name:          write_report.pm
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
package write_report;
use English;
use strict;
#
# Opens the daily report output file
#
sub write_report::openfile {
#
#   File definitions
#
  $write_report::dailyreportfile = "$main::currentDir/report/daily.report";
#        print "Report file name: $write_report::dailyreportfile\n";
  open (DAILYREPORT, ">$write_report::dailyreportfile")
    || die "Cant open DAILYREPORT $write_report::dailyreportfile";
#
#   Put out header
#
  my ($header) = &syswatchfuncts::reportheader ("System Watch (syswatch) Report", $main::logid);
  writeline ($header);
#        writeline (&syswatchfuncts::reportbar);
}
sub write_report::writeline {
  print $ARG[0], "\n";
  # print DAILYREPORT $ARG[0], "\n";
}
