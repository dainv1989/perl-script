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

# function 	: get_data
# description	: retreive binary data from file at offset position with specific size
# param
#			$offset	: offset position
#			$size		: number of bytes will be read
#			$file		: file name
# return		: gotten value as an integer number
#
sub get_data{
	my ($offset, $size, $file) = @_;
	my $buffer = "";
	my $hex = "";
	my $num_bytes = 0;
	my $ret = 0;

	open(FILE, "<", $file)
		or warn "Error! Opening $file is failed";
	binmode(FILE);

	seek(FILE, $offset, 0);
	$num_bytes = read(FILE, $buffer, $size, $offset);
	my $len = length($buffer) - $size;
	$buffer = substr($buffer, $len, $size);

	if ( $num_bytes > 0){
		# if RIGHT most bit is MOST SIGNIFICANT (Little-Endian)
		# REVERSE bytes order
		my @bytes = reverse(split(//, $buffer));
		foreach(@bytes){
			$hex = sprintf("%s%02x", $hex, ord($_));
		}
		#print "$hex\n";
	}
	$ret = hex($hex);
	close(FILE);
	return $ret;
}

# function		: get_index
# description	: get column index of testcase file by header name
# param
#			$file	: file name
# return		: a hash with keys are header name in testcase file
#
sub get_index{
	my $file = $_[0];
	my %header = ();

	open(FILE, "<", $file)
		or warn "Error! Opening $file is failed";

	my @tmp = <FILE>;
	chomp($tmp[0]);
	my @tops = split(',', $tmp[0]);
	# get index of needed column
	for (my $i = 0; $i <= $#tops; $i++){
		$header{$tops[$i]} = $i if ($tops[$i] ne "");
	}

	close(FILE);
	return %header;
}

# function test code
my $val = get_data(0, 2, "test.bin");
print "get_data result: $val\n";
$val = get_data(4, 2, "test.bin");
print "get_data result: $val\n";

my %header = ();
%header = get_index ("testcase.csv");
my @keys = keys(%header);
foreach(@keys){
	print "$_ :: $header{$_}\n";
}
# end test
