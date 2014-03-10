########################################
# file name	:
# description	:
# author		: Dai Nguyen-Van
# email		:
# creation date	: 07/03/2014
########################################
#!/usr/bin/perl
use strict;
use warnings;
use Fcntl;

sub create_log{
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
	my $log_dir = sprintf("%d%02d%02d", ($year + 1900), ($mon + 1), $mday);

	# check existence of log directory
	if (not -d $log_dir){
		mkdir($log_dir) or warn "create log directory failed";
	}

	my $log_file = sprintf("$log_dir/autotest_%02d%02d%02d.log", $hour, $min, $sec);
	open(LOG, ">", $log_file)
		or warn "create log file failed";

	print LOG "";
	close(LOG);
	return $log_file;
}

#my $log_file = create_log();
my $file_name = "test.txt";
my $mode = 0222;
chmod $mode, $file_name;
