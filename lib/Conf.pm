#-********************************************************************************
#
#   File Name:          Conf.pm
#   Author:             Jens Madsen
#
#   Revision history:
#      2020/06/30  Jens Madsen
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
package Conf;
use English;
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use File::Spec;
use Cwd;
my $workdir = getcwd;
my $usageMsg;
my %cmdlineopts;
#
# Initial Configuration
#
our %opts = (
    'config'            => {
                        'value'          => './tools.conf',
                        'type'           => 'string',
                        'description'    => 'The configuration file for host processing.',
                        'action'         => '',
                        },
    'date'              => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The current date.',
                        'action'         => '',
                        },
    'debug'             => {
                        'value'          => '0',
                        'type'           => 'integer',
                        'description'    => 'Turns on and off of debug.',
                        'action'         => '',
                        },
    'dhcp_dir'          => {
                        'value'          => 'products/dhcp/FailOver/',
                        'type'           => 'string',
                        'description'    => 'Directory for DHCP files',
                        'action'         => '',
                        },
    'dhcp_peer'         => {
                        'value'          => 'mydomain',
                        'type'           => 'string',
                        'description'    => 'DHCP peer',
                        'action'         => '',
                        },
    'dns_dir'           => {
                        'value'          => 'products/mydomains/',
                        'type'           => 'string',
                        'description'    => 'Directory for DNS files',
                        'action'         => '',
                        },
    'domain'            => {
                        'value'          => 'mydomain.local',
                        'type'           => 'string',
                        'description'    => 'The domain name.',
                        'action'         => '',
                        },
    'gid'               => {
                        'value'          => 'none',
                        'type'           => 'string',
                        'description'    => 'The user gid.',
                        'action'         => '',
                        },
    'home'              => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The user home directory',
                        'action'         => '',
                        },
    'host'              => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The host where the process is run.',
                        'action'         => '',
                        },
    'hostname'          => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The name of the website.',
                        'action'         => '',
                        },
    'hosttable'         => {
                        'value'          => 'HostTable.tab',
                        'type'           => 'string',
                        'description'    => 'Path to the HostTable',
                        'action'         => '',
                        },
    'jobname'           => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The jobname of the process.',
                        'action'         => '',
                        },
    'log_level'         => {
                        'value'          => '1',
                        'type'           => 'integer',
                        'description'    => 'The level of information in log file (0-2).',
                        'action'         => '',
                        },
    'loghome'           => {
                        'value'          => './',
                        'type'           => 'integer',
                        'description'    => 'The location of the log file.',
                        'action'         => '',
                        },
    'mail_admin'        => {
                        'value'          => 'root@mydomain.com',
                        'type'           => 'string',
                        'description'    => 'The admin user to mail the report.',
                        'action'         => '',
                        },
    'mail_user'         => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The user to mail the report.',
                        'action'         => '',
                        },
    'mailservers'       => {
                        'value'          => 'ms1:10,ms2:10',
                        'type'           => 'string',
                        'description'    => 'The mail servers name and priority.',
                        'action'         => '',
                        },
    'mydomains_path'     => {
                        'value'          => '/var/named/chroot/var/named/mydomains/',
                        'type'           => 'string',
                        'description'    => 'The path to mydomains.',
                        'action'         => '',
                        },
    'namedsiteinc'      => {
                        'value'          => './sites.inc',
                        'type'           => 'string',
                        'description'    => 'The named.conf include files.',
                        'action'         => '',
                        },
     'nameservers'      => {
                        'value'          => 'ns1,ns2',
                        'type'           => 'string',
                        'description'    => 'The name servers names.',
                        'action'         => '',
                        },
    'network'           => {
                        'value'          => '10.20.30',
                        'type'           => 'string',
                        'description'    => 'The Classs C network address (xxx.xxx.xxx).',
                        'action'         => '',
                        },
    'pass'              => {
                        'value'          => 'none',
                        'type'           => 'string',
                        'description'    => 'The user password.',
                        'action'         => '',
                        },
    'progname'          => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The programs name.',
                        'action'         => '',
                        },
    'pwd'               => {
                        'value'          => '0',
                        'type'           => 'string',
                        'description'    => 'The current directory.',
                        'action'         => '',
                        },
    'roam_range'        => {
                        'value'          => '60,80',
                        'type'           => 'string',
                        'description'    => 'Directory for DHCP files',
                        'action'         => '',
                        },
    'serial'            => {
                        'value'          => '0000000000',
                        'type'           => 'integer',
                        'description'    => 'The NAMED serial id (NNNNNNNNNN).',
                        'action'         => '',
                        },
    'sipiserver'        => {
                        'value'          => 'sip',
                        'type'           => 'string',
                        'description'    => 'The pbx ip.',
                        'action'         => '',
                        },
    'siteconfig'        => {
                        'value'          => './website.cfg',
                        'type'           => 'string',
                        'description'    => 'The site configuration file for WebSite processing.',
                        'action'         => '',
                        },
    'sitelist'          => {
                        'value'          => './site.lst',
                        'type'           => 'string',
                        'description'    => 'A list of the websites.',
                        'action'         => '',
                        },
    'sitename'          => {
                        'value'          => 'None',
                        'type'           => 'string',
                        'description'    => 'The website name.',
                        'action'         => '',
                        },
    'uid'               => {
                        'value'          => 'none',
                        'type'           => 'string',
                        'description'    => 'The user uid.',
                        'action'         => '',
                        },
    'user'              => {
                        'value'          => 'none',
                        'type'           => 'string',
                        'description'    => 'The user running the report',
                        'action'         => '',
                        },
    'var_etc'           => {
                        'value'          => './products/var_etc/',
                        'type'           => 'string',
                        'description'    => 'Directory for var etc files',
                        'action'         => '',
                        },
    'webserver'         => {
                        'value'          => 'www',
                        'type'           => 'string',
                        'description'    => 'The webserver name.',
                        'action'         => '',
                        },
);
print "Conf\n";
#
# Usage message
#
    $usageMsg =
	"usage: $opts{'progname'}{'value'} -[eq] [-d <today|yesterday>] [-h <cnt>] [-u <cnt>]
       		[--verp_mung[=<n>]] [--verbose_msg_detail] [--iso_date_time]
       		[-m|--uucp_mung] [-i|--ignore_case] [--smtpd_stats] [--mailq]
       		[--problems_first] [--rej_add_from] [--no_bounce_detail]
       		[--no_deferral_detail] [--no_reject_detail] [file1 [filen]]

       		$opts{'progname'}{'value'} --[version|help]";

#
# Create an new Instanciation
#
sub new { 
    my ($class, $args) = @ARG; 
    my $self = {};
    &GetCmdLineOptions;
    #&GetConfigFileOption;
    if (defined($cmdlineopts{'config'}{'value'})) {
	&ProcessConfigurationFile($cmdlineopts{'config'}{'value'});
    } else {
	&ProcessConfigurationFile($opts{'config'}{'value'});
    }
    &MergeOptions;
#
# Runtime Configuration
#
    $opts{'home'}{'value'} = $ENV{'HOME'};
    $opts{'user'}{'value'} = $ENV{'LOGNAME'};
    $opts{'hostname'}{'value'} = $ENV{'LOGNAME'};
    $opts{'pwd'}{'value'} = $ENV{'PWD'};
    ($opts{'user'}{'value'},$opts{'pass'}{'value'},$opts{'uid'}{'value'},$opts{'gid'}{'value'})
	= getpwnam($opts{'user'}{'value'})
	or die "$opts{'user'}{'value'} not in passwd file";
    $opts{'loghome'}{'value'} = File::Spec->catdir ($opts{'home'}{'value'}, "/var/log");
    $opts{'serial'}{'value'} = `date "+%y%m%d%H%M"`;
    chomp $opts{'serial'}{'value'};
    $opts{'date'}{'value'} = `date "+%Y%m%d-%H:%M"`;
    chomp $opts{'date'}{'value'};
    $opts{'host'}{'value'} = `hostname`;
    chomp $opts{'host'}{'value'};
    $opts{'progname'}{'value'} = $PROGRAM_NAME;
    &ReportOptions;
    #print "End of new().\n";
    return bless $self, $class;
}
#
# Get command line input options
#
sub GetCmdLineOptions {
  print "GetCmdLineOptions\n";

  my $release = "1.0.4-jm";
  my $isoDateTime = 0;	# Don't use ISO date/time formats
  # Some pre-inits for convenience
  GetOptions (
      "config=s"                => \$cmdlineopts{'config'}{'value'},
      "date=s"                  => \$cmdlineopts{'date'}{'value'},
      "debug=i"                 => \$cmdlineopts{'debug'}{'value'},
      "dhcp_dir=s"              => \$cmdlineopts{'dhcp_dir'}{'value'},
      "dhcp_peer=s"             => \$cmdlineopts{'dhcp_peer'}{'value'},
      "dns_dir=s"               => \$cmdlineopts{'dns_dir'}{'value'},
      "domain=s"                => \$cmdlineopts{'domain'}{'value'},
      "gid=s"                   => \$cmdlineopts{'gid'}{'value'},
      "home=s"                  => \$cmdlineopts{'home'}{'value'},
      "host=s"                  => \$cmdlineopts{'host'}{'value'},
      "hostname=s"              => \$cmdlineopts{'hostname'}{'value'},
      "hosttable=s"             => \$cmdlineopts{'hosttable'}{'value'},
      "jobname=s"               => \$cmdlineopts{'jobname'}{'value'},
      "log_level=i"             => \$cmdlineopts{'log_level'}{'value'},
      "loghome=i"               => \$cmdlineopts{'loghome'}{'value'},
      "mail_admin=s"            => \$cmdlineopts{'mail_admin'}{'value'},
      "mail_user=s"             => \$cmdlineopts{'mail_user'}{'value'},
      "mailservers=s"           => \$cmdlineopts{'mailservers'}{'value'},
      "mydomains_path=s"        => \$cmdlineopts{'mydomains_path'}{'value'},
      "namedsiteinc=s"          => \$cmdlineopts{'namedsiteinc'}{'value'},
      "network=s"               => \$cmdlineopts{'network'}{'value'},
      "pass=s"                  => \$cmdlineopts{'pass'}{'value'},
      "progname=s"              => \$cmdlineopts{'progname'}{'value'},
      "pwd=s"                   => \$cmdlineopts{'pwd'}{'value'},
      "roam_range=s"            => \$cmdlineopts{'roam_range'}{'value'},
      "serial=i"                => \$cmdlineopts{'serial'}{'value'},
      "sipiserver=s"            => \$cmdlineopts{'sipiserver'}{'value'},
      "siteconfig=s"            => \$cmdlineopts{'siteconfig'}{'value'},
      "sitelist=s"              => \$cmdlineopts{'sitelist'}{'value'},
      "sitename=s"              => \$cmdlineopts{'sitename'}{'value'},
      "uid=s"                   => \$cmdlineopts{'uid'}{'value'},
      "user=s"                  => \$cmdlineopts{'user'}{'value'},
      "var_etc=s"               => \$cmdlineopts{'var_etc'}{'value'},
      "webserver=s"             => \$cmdlineopts{'webserver'}{'value'},

      "help"                    => sub { Usage(0) },
      "show_options"            => sub { ReportOptions(0) },
      "version"                 => sub { ShowVersion(0) },
      ) || die "$usageMsg\n"

      #print "Configuration file: $opts{'config'}{'value'}\n";
      #print "Log file: $opts{'logfile'}{'value'}\n";
}
############################################
# Get configuration file from command line
############################################
sub ShowVersion {
    print "Version: $opts{'version'}{value}\n\n";
}
############################################
# Get configuration file from command line
############################################
sub GetConfigFileOption {
    print "GetConfigFileOption\n";
    for (my $i = 0; $i < @ARGV; $i++) {
	if (my ($value) = ($ARGV[$i] =~ /--config= \"* (.*) [\"\']*/xi)) {
	    $opts{'config'}{'value'} = $value;
	    last;
	}
	elsif ($ARGV[$i] =~ /--config/) {
	    if ($i + 1 < @ARGV) {
		$opts{'config'}{'value'} = $ARGV[$i+1];
	    }
	    else {
		&Usage;
		die "Configuration error with configuration file\n";
	    }
	}
    }
    #print "Configuraton file:  $opts{'config'}{'value'}\n";
}
############################################
# Merge %cmdlineopts into %opts
############################################
sub MergeOptions {
    print "Merge Options\n";
    foreach my $opt (sort keys (%cmdlineopts)) {
	#printf "    %-12s", $opt;
	if (defined($cmdlineopts{$opt}{'value'})) {
	    #printf "    %-12s", $cmdlineopts{$opt}{'value'};
	    $opts{$opt}{'value'} = $cmdlineopts{$opt}{'value'};
	} else {
	    #print "  $opt is not defined in \$opt.\n";
	}
	#print "\n";
    }
}
############################################
# Show configuration Options
############################################
sub ReportOptions {
	print "Report Options\n";
	#return 1;
	#print Dumper (%opts);
	print "Options:\n";
	foreach my $opt (sort keys (%opts)) {
		printf "    %-12s", $opt;
		my $state = "Undefined";
		if (defined($opts{$opt}{'value'})) {
			$state = $opts{$opt}{'value'};
		}
		if (!exists($opts{$opt}{'type'})) {
		    print "  $opt has no type\n";
		} else {
		    printf "  %-8s",$opts{$opt}{'type'};
		}
		if (!exists($opts{$opt}{'description'})) {
		    printf "  %-50s has no description", $opt;
		} else {
		    printf "  %-50s", $opts{$opt}{'description'};
		}
		if ($opts{$opt}{'type'} eq 'list') {
		# 	foreach my $elem (@{$state}) {
		# 		print "  $elem";
		# 	}
		# 	print "\n";
		} else {
		    print " $state\n";
		}
		#print "\n";
	}
	print "\n";
}
#####################################################
# Read the configuration file and parse the commands
#####################################################
sub ProcessConfigurationFile {
    my $conffile = shift @ARG;
    print "ProcessConfigurationFile: $conffile\n";
    if (-e $conffile) {
	open (CONF, $conffile) ||
	    die "Cant open CONF: $conffile -- $ERRNO\n";
	my (@confText) = <CONF>;
	close (CONF);
	my %list;
	my ($line);
	foreach $line (@confText) {
	    chomp $line;
	    #print "Conf line: $line\n";
	    $line =~ s/\ *\#.*$//;
	    #print "Conf line: $line\n";
	    my ($parameter, $value);
	    if ($line !~ / \S /x ) {}
	    elsif (($parameter, $value) = ($line=~ /(\S+) \s* \= \s* (.*?) \s* $ /xi)) {
		#print "Parameter ($parameter) = $value\n";
		if (exists $opts{$parameter}) {
		    my $clean_value;
		    my $type = $opts{$parameter}{'type'};
		    if ($type eq 'integer') {
			($clean_value = $value) =~ /^(\d+)/x;
			#print "Clean value: $clean_value\n";
			$opts{$parameter}{'value'} = $value;
		    } elsif ($type eq 'string') {
			($clean_value = $value) =~ /^ \"* (\d+) \"* $/x;
			#print "Clean value: $clean_value\n";
			$opts{$parameter}{'value'} = $value;
		    } elsif ($type eq 'list') {
			($clean_value = $value) =~ /^ \"* (\d+) \"* $/x;
			#print "Clean value: $clean_value\n";
			push @{$list{$parameter}}, split (/[, ]+/, $clean_value);
			#print "Clean value: $clean_value\n";
            #foreach my $elem (@list) {
              #print "  $elem";
            #}
#            $opts{$parameter}{'value'} = [@list];
            #print "\n";
		    } elsif ($type eq 'shasum') {
			my @pair = ($value =~ / (\S+) \s+ (.*) /x);
			#print "Pair value 1: $pair[0]\n";
			#print "Pair value 2: $pair[1]\n";
			push @{$list{$parameter}}, \@pair;
			#print "Clean value: $clean_value\n";
			#foreach my $elem (@list) {
			#print "  $elem";
			#}
#            $opts{$parameter}{'value'} = [@list];
            #print "\n";
		    }
		} else {
		    print "Invalid parameter: $parameter -> $value\n";
		}
	    } else {
		print "Invalid line: $line\n";
	    }
	}
	foreach my $parm (keys %list) {
	    $opts{$parm}{'value'} = $list{$parm};
	}
    }
}
###########################################
# Prints Usage information.
###########################################
sub Usage {
  print "$usageMsg\n";
}
###########################################
# Data access routines.
###########################################
########################
#
# The configuration file for host processing.
#
sub get_config {
    my $self = shift;
    return $opts{'config'}{'value'};
}
#
# The current date.
#
sub get_date {
    my $self = shift;
    return $opts{'date'}{'value'};
}
#
# Turns on and off of debug.
#
sub get_debug {
    my $self = shift;
    return $opts{'debug'}{'value'};
}
#
# Directory for DHCP files
#
sub get_dhcp_dir {
    my $self = shift;
    return $opts{'dhcp_dir'}{'value'};
}
#
# DHCP peer
#
sub get_dhcp_peer {
    my $self = shift;
    return $opts{'dhcp_peer'}{'value'};
}
#
# Directory for DNS files
#
sub get_dns_dir {
    my $self = shift;
    return $opts{'dns_dir'}{'value'};
}
#
# The domain name.
#
sub get_domain {
    my $self = shift;
    return $opts{'domain'}{'value'};
}
#
# The user gid.
#
sub get_gid {
    my $self = shift;
    return $opts{'gid'}{'value'};
}
#
# The user home directory
#
sub get_home {
    my $self = shift;
    return $opts{'home'}{'value'};
}
#
# The host where the process is run.
#
sub get_host {
    my $self = shift;
    return $opts{'host'}{'value'};
}
#
# The name of the website.
#
sub get_hostname {
    my $self = shift;
    return $opts{'hostname'}{'value'};
}
#
# Path to the HostTable
#
sub get_hosttable {
    my $self = shift;
    return $opts{'hosttable'}{'value'};
}
#
# The jobname of the process.
#
sub get_jobname {
    my $self = shift;
    return $opts{'jobname'}{'value'};
}
#
# The level of information in log file (0-2).
#
sub get_log_level {
    my $self = shift;
    return $opts{'log_level'}{'value'};
}
#
# The location of the log file.
#
sub get_loghome {
    my $self = shift;
    return $opts{'loghome'}{'value'};
}
#
# The admin user to mail the report.
#
sub get_mail_admin {
    my $self = shift;
    return $opts{'mail_admin'}{'value'};
}
#
# The user to mail the report.
#
sub get_mail_user {
    my $self = shift;
    return $opts{'mail_user'}{'value'};
}
#
# The mail server 1 ip.
#
sub get_mailservers {
    my $self = shift;
    return $opts{'mailservers'}{'value'};
}
#
# The path to mydomains.
#
sub get_mydomains_path {
    my $self = shift;
    return $opts{'mydomains_path'}{'value'};
}
#
# The named.conf include files.
#
sub get_namedsiteinc {
    my $self = shift;
    return $opts{'namedsiteinc'}{'value'};
}
#
# The name servers.
#
sub get_nameservers {
    my $self = shift;
    return $opts{'nameservers'}{'value'};
}
#
# The Classs C network address (xxx.xxx.xxx).
#
sub get_network {
    my $self = shift;
    return $opts{'network'}{'value'};
}
#
# The user password.
#
sub get_pass {
    my $self = shift;
    return $opts{'pass'}{'value'};
}
#
# The programs name.
#
sub get_progname {
    my $self = shift;
    return $opts{'progname'}{'value'};
}
#
# The current directory.
#
sub get_pwd {
    my $self = shift;
    return $opts{'pwd'}{'value'};
}
#
# Directory for DHCP files
#
sub get_roam_range {
    my $self = shift;
    return $opts{'roam_range'}{'value'};
}
#
# The first eight characters of the NAMED serial id (NNNNNNNN).
#
sub get_serial {
    my $self = shift;
    return $opts{'serial'}{'value'};
}
#
# The pbx ip.
#
sub get_sipiserver {
    my $self = shift;
    return $opts{'sipiserver'}{'value'};
}
#
# The site configuration file for WebSite processing.
#
sub get_siteconfig {
    my $self = shift;
    return $opts{'siteconfig'}{'value'};
}
#
# A list of the websites.
#
sub get_sitelist {
    my $self = shift;
    return $opts{'sitelist'}{'value'};
}
#
# The website name.
#
sub get_sitename {
    my $self = shift;
    return $opts{'sitename'}{'value'};
}
#
# The user uid.
#
sub get_uid {
    my $self = shift;
    return $opts{'uid'}{'value'};
}
#
# The user running the report
#
sub get_user {
    my $self = shift;
    return $opts{'user'}{'value'};
}
#
# Directory for var etc files
#
sub get_var_etc {
    my $self = shift;
    return $opts{'var_etc'}{'value'};
}
#
# The webserver ip.
#
sub get_webserver {
    my $self = shift;
    return $opts{'webserver'}{'value'};
}

1
