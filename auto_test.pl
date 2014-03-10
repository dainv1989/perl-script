########################################
# 
# creation date	: 07/03/2014
########################################
#!/usr/bin/perl
use strict;
use warnings;
use File::Copy;

open (my $test_cases, "<", "testcase.csv")
	or die "opening testcase.csv is failed\n";

# read test cases file
my $app = "ctl_conv";
my @content = <$test_cases>;
chomp(@content);

my $line = "";
for (my $i = 1; $i <= $#content; $i++){
	$line = $content[$i];
	my @params = [];
	# if current line is empty, ignore it
	if ($line eq ""){
		next;
	}

	# split parameters from a line of testcases file
	my @tmp = split(',', $line);
	# if current line has not at least two parameters, ignore it
	if(@tmp < 2){
		next;
	}

	my @attr = [];
	for(my $i = 0; $i <= $#tmp; $i++){
		# remove all whitespace characters;
		$tmp[$i] =~ s/\s//g;

		# if there are more information inside single brackets
		# separate file name with extended information
		if ($tmp[$i] =~ m/^(.*)\((.+)\)/i ){
			$tmp[$i] = $1;
			$attr[$i] = $2;
			print "$tmp[$i] -- $attr[$i]\n";
		}
	}

	my $input = "./input/$tmp[0]";
	my $output = "./output/$tmp[1]";
	my $struct = "./struct/struct.def";
	my $ref_key = "./ref_key/ref_key.def";

	if (@tmp >= 4){
		$struct = "./struct/$tmp[2]";
		$ref_key = "./ref_key/$tmp[3]";
	}

	# overwrite definition files needed for testing
	copy($struct, "./def/struct.def")
		or warn "moving $struct file is failed\n";
	copy($ref_key, "./def/ref_key.def")
		or warn "moving $ref_key file is failed\n";

	@params = [$input, $output, "./def/struct.def", "./def/ref_key.def"];
	# set attribute or delete file depend on extended information
	for(my $i = 0; $i < $#attr; $i++){
		# delete file
		if($attr[$i] eq "x"){
			unlink($params[$i]);
		}
		# set attributes file corresponding
		elsif ($attr[$i] =~ m/^\d+$/i){
			chmod q{$attr[$i]}, $params[$i];
		}
	}
	# build application command
	my $cmd = "$app $output $input";
	print "running command : $cmd\n";

	# capture output message
	#my $msg = `$cmd`;
	#print "message returned: $msg\n";
}
