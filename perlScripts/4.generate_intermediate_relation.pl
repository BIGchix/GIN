#!/usr/bin/perl
use strict;
use warnings;

if(@ARGV != 1){
	die "Usage: perl $0 <entrez_sorted_kept_KEGG_ file>\n";
}

my $input=$ARGV[0];
my $output="intermediate_$input";

open(IN,$input) or die "OpenError: $input, $!\n";
open(OUT,">$output") or die "OpenError: $output, $!\n";

print OUT "start\tend\ttype\n";
while(<IN>){
	$_=~s/[\n\r]//g;
	my @data=split(/\t/,$_);
	$data[2]=~/([a-z]+)\^with\^/;
	if($1 ne "activation" and $1 ne "inhibition"){
		next;
	}
        my $type4="type4-$1";
	my $intermediate = "$data[0]\;$data[1]";
	my @left =split(/\_/,$data[0]);
	my @right=split(/\_/,$data[1]);
	if(@left > 1){
		foreach my $subunit (@left){
			print OUT "$subunit\t$data[0]\ttype1\n";
		}
	}
	if(@right > 1){
		foreach my $subunit (@right){
			print OUT "$subunit\t$data[1]\ttype1\n";
		}
	}
	print OUT "$data[0]\t$intermediate\ttype2\n";
	print OUT "$data[1]\t$intermediate\ttype3\n";
	print OUT "$intermediate\t$data[1]\t$type4\n"; #activation or inhibition
}
close IN;
close OUT;
