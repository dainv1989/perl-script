########################################################
# file name     : dict_attack.pl
# description   : password dictionary attack demo
# creation date : 20-01-2014
# author        : dainv
# update
#
########################################################
#!/usr/bin/perl
use strict;
use warnings;
use Digest::SHA;
use autodie qw(open close);

# command arguments
my $dic = $ARGV[0];
my $pwd = $ARGV[1];

# read input cipher texts and dictionary
open (my $input, '<', $pwd);
my @ciphers = <$input>;
# remove end of line characters
chomp(@ciphers);

print "\n";
print "dictionary attack demo\n";
print "encrypt algorithm: SHA1\n";
print "======================================\n\n";

foreach my $cipher(@ciphers){
    my $password = "*";
    my $count = 0;
    my $factor = 0;

    # calculate factor depends on length of cipher text
    $factor = length($cipher);
    if ($factor == 40) {
        $factor = 1;
    }
    elsif(($factor == 56) ||
          ($factor == 64) ||
          ($factor == 96) ||
          ($factor == 128))
    {
        $factor = $factor * 4;
    }
    else {
        next;
    }

    # create new SHA algorithm object with key length is factor
    my $sha = Digest::SHA->new($factor);
    open (my $dict, '<', $dic);

    while(<$dict>){
        chomp;
        $sha->add($_);
        # encrypt each word with SHA1 algorithm
        my $encrypt_text = $sha->hexdigest;

        # compare with cipher text, if matches
        if($encrypt_text eq $cipher){
            $password = $_;
            last;
        }
        # count number of tested words
        $count++;
    }

    # print out result, "*" if not found
    print "$cipher\:\:$password\t[ATTEMPT\:\:$count words]\n";
    # close dictionary file handle
    close ($dict);
}

# close input file handle
close($input);