#!/usr/bin/perl
use strict;
use warnings;

if(@ARGV != 2){
	die "Usage: perl $0 <kept_ file> <three letter organism from KEGG>\n";
}

my $input=$ARGV[0];
my $org=$ARGV[1];
my $output="entrez_sorted_$input";

open(IN,$input) or die "OpenError: $input, $!\n";
open(OUT,">$output") or die "OpenError: $output, $!\n";

while(<IN>){
	$_=~s/[\n\r]//g;
	$_=~s/$org\://g;
	my @data =split(/\t/,$_);
	my @left=split(/\_/,$data[0]);
	my @right=split(/\_/,$data[1]);
	if(@left > 1){
		@left = sort @left;
		$data[0] = join("_",@left);
	}
	if(@right > 1){
		@right = sort @right;
		$data[1] = join("_",@right);
	}
	print OUT "$data[0]\t$data[1]\t$data[2]\n";
}
close IN;
close OUT;
