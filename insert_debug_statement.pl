###################################################################################################
#
# script name   : insert_debug_statement.pl
# description   : insert debug trace statement for every function in source file
#               : determine what functions are called in executing application
#               : use for investigation C plus plus source code
# author        : Dai Nguyen-Van
# email         : dai.nguyenvan@toshiba-tsdv.com
# company       : Toshiba Software Development Vietnam
# update        :
#=======================================
# 07/10/2013    : initialization
#=======================================
# command       : [script_name] [input_file] [debug_statement]
# notes         : output file will be genated automatically in the same directory
#               : [output_file_name] = [input_file_name] + "_debug" + extension
#               : use for only .cpp file now
###################################################################################################
use Fcntl;                        # file handle package

# asignment variables
my @valid_file_extension = (".cpp", ".c", ".pl", ".py", ".cs");
my $input_file = $ARGV[0];
my $debug_statement = $ARGV[1];
my $output_file = "";

# check existence of input arguments
# input file argument
if ((!(-e $ARGV[0])) || ($input_file eq ""))
{
    print "input file is absence or not exist\n";
    print "terminate program...\n";
    exit;
}

# debug statement argument
if ($debug_statement eq "")
{
    print "debug statement is absence\n";
    print "terminate program...\n";
    exit;
}

$idx = rindex($input_file, '.');        # position of last dot character
$len = length($input_file);             # length of input file name
if ($idx != -1)
{
    $input_file_extension = substr($input_file, $idx, ($len - $idx));
    
    # check validation of input file extension
    $valid = 0;
    foreach (@valid_file_extension)
    {
        if ($input_file_extension eq $_)
        {
            $valid = 1;
        }
    }
    
    # if valid, print input and output file name
    if ($valid == 1)
    {
        # output file name
        $output_file = substr($input_file, 0, $idx)."_debug".$input_file_extension;
        print "input file\t: $input_file\n";
        print "output_file\t: $output_file\n";
    }
    # if invalid
    else
    {
        print "invalid input file extension\n";
        print "terminate program...\n";
        exit;
    }
}
# file has no extension
else
{
    print "invalid input file $input_file\n";
    print "terminate program...\n";
}

# open input and output file
sysopen (IN, $input_file, O_RDONLY);
sysopen (OUT, $output_file, O_CREAT | O_TRUNC | O_WRONLY, 0755);

# read data of input file
@content = <IN>;
$number_of_line = @content;
$count = 0;
while ($count < $number_of_line)
{
    $line = $content[$count];
    $count++;
    # if current line is function declaration
    if ($line =~ /^\w+\**\s+\**\s*\**\w+:*\w+\(.*\){*/)
    {
        print OUT "$line";
        # if next line is curve bracket '{'
        if ($content[$count] =~ /^\s*{\n/)
        {
            print OUT "$content[$count]";
            print OUT "\t$debug_statement\n";
            $count++;
        }
        else
        {
            print OUT "\t$debug_statement\n";
        }
    }
    else
    {
        print OUT "$line";
    }
}

# close input, output file handle
close IN;
close OUT;
