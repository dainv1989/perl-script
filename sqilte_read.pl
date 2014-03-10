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
use DBI;

# function		: get_rdb
# description	: retrieve data from Relation database
#			: data is specified by table name, column name and row number
# pre-condition	: RDB file can be access without authentication
#			: use for SQLite rdb only
# param
#			$rdb		: RDB file
#			$table	: table name
#			$column	: column name
#			$row		: row number (base-0)
# return		: value of cell in RDB
#
sub get_rdb{
	my ($rdb, $table, $column, $row_id) = @_;
	my $value = 0;
	my $driver = "SQLite";
	my $dsn = "DBI:$driver:database=$rdb";

	my $query = sprintf("SELECT %s FROM %s", $column, $table);
	my $dbh = DBI->connect($dsn) or warn DBI::errstr;
	my $sth = $dbh->prepare($query);
	$sth->execute() or warn DBI::errstr;
	my $i = 0;
	my @data;
	while(@data = $sth->fetchrow_array()){
		if ($i == $row_id){
			$value = $data[0];
			last;
		}
		$i++; 
	}
	$sth->finish();
	return $value;
}

# function test code
my $val = get_rdb("rdb.db", "CPU", "cpu_no", 0);
print "cpu_no: $val\n";
$val = get_rdb("rdb.db", "FUNCTION", "scan_time", 4);
print "scan_time: $val\n";
# end testing

# print all available drivers supported by DBI package
#my @avai_drivers = DBI->available_drivers;
#foreach(@avai_drivers){
#	print "$_\n";
#}

my $driver = "SQLite";
my $rdb = "rdb.db";
my $dsn = "DBI:$driver:database=$rdb";
#my $userid = "";
#my $password = "";

my $dbh = DBI->connect($dsn) or warn DBI::errstr;

my $stt = "SELECT cpu_no, revision, project_no, period FROM CPU";
my $sth = $dbh->prepare($stt);
$sth->execute() or warn DBI::errstr;

while(my @data = $sth->fetchrow_array()){
	print "cpu_no: $data[0]\n";
	print "revision: $data[1]\n";
}
$sth->finish();
