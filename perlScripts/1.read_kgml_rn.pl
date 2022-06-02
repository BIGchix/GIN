#/usr/bin/perl
use strict;
use warnings;

if(@ARGV != 2){
	die "Usage: perl $0 <kgml file> <three letter organism from KEGG>\n";
}

my $input=$ARGV[0];
my $org=$ARGV[1];
$input=~/($org\d+)/;
my $path=$1;
my $output="rn_$path\.kgml";

open(IN,$input) or die "OpenError: $input, $!\n";
open(OUT,">$output") or die "OpenError: $output, $!\n";

my %node;
my %rn;
my $n=0;
while(<IN>){
	$_=~s/[\n\r]//g;
	my $line=$_;
	my $id;
	my @gene;
	my @rnType;
	if($line=~/\<entry id=\"(\d+)\"/){
		$id=$1;
		if($line=~/type=\"gene\"/){
			$line=~/name=\"($org\:.+)\" type/;
			@gene=split(/\s/,$1);
			foreach my $g (@gene){
				$g=~s/[_\-\;]/\+/g;
				$node{$id}{$g}=1;
				#print "$id\t$g\n";
			}
		}elsif($line=~/type=\"group\"/){
			#print "Group id: $id\n";
			my $tmp=<IN>;
			#print "$tmp\n";
			while(not $tmp=~/\<\/entry\>/){
				#print "$tmp\n";
				if($tmp=~/\<component id=\"(\d+)\"/){
					$node{$id}{"group"}{$1}=1;
					#print "$id group $1\n";
				}
				$tmp=<IN>;
			}
		}
	}elsif($line=~/\<reaction .+ name=\"(rn:R\d+)\".+type=\"([a-z]+)\"/){
		$n++;
		my $rnID=$1;
		my $type=$2;
		#my @rnType;
		my $tmp=<IN>;
		my @substrates;
		my @products;
		#print "$tmp\n";
		while(not $tmp=~/\<\/reaction\>/){
			if($tmp=~/substrate .+ name=\"(.+)\"/){
				push(@substrates,$1);
				#print "$id1 -> $id2\t$1\t$2\n";
			}elsif($tmp=~/product .+ name=\"(.+)\"/){
				push(@products,$1);
			}
			$tmp=<IN>;
			#print "$tmp\n";
		}
		$rn{$n}=join("\t",($rnID,$type,join(";",@substrates),join(";",@products)));
	}
}
close IN;

#output
foreach my $num (sort {$a <=> $b} keys %rn){
	print OUT "$path-$num\t$rn{$num}\n";
}
close OUT;
