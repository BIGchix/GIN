#!/usr/bin/perl
use strict;
use warnings;

my $input=$ARGV[0];
my $output1="kept_$input";
my $output2="left_$input";

open(IN,$input) or die "OpenError: $input, $!\n";
open(OUT1,">$output1") or die "OpenError: $output1, $!\n";
open(OUT2,">$output2") or die "OpenError: $output2, $!\n";

while(<IN>){
	$_=~s/[\n\r]//g;
	my @data=split(/\t/,$_);
	if(@data > 2){
		print OUT1 "$data[0]\t$data[1]\t$data[2]\n";
	}else{
		print OUT2 "$_\n";
	}
}
close IN;
close OUT1;
close OUT2;
