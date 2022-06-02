#/usr/bin/perl
use strict;
use warnings;

my $input=$ARGV[0];
my $output="list_$ARGV[0]";

open(IN,$input) or die "OpenError: $input, $!\n";
open(OUT,">$output") or die "OpenError: $output, $!\n";
open(GRP,">grp_$ARGV[0]") or die "OpenError: grp_$ARGV[0], $!\n";

my %node;
my %link;
my %checkRel;
#my $lineNum=0;
while(<IN>){
  #$lineNum++;
	$_=~s/[\n\r]//g;
	my $line=$_;
	my $id;
	my @gene;
	if($line=~/\<entry id=\"(\d+)\"/){
		$id=$1;
		if($line=~/type=\"gene\"/){
			$line=~/name=\"(.+)\" type/;
			@gene=split(/\s/,$1);
			foreach my $g (@gene){
				$g=~s/[_\-\;]/\+/g;
				$node{$id}{$g}=1;
				#print "$id\t$g\n";
			}
		}elsif($line=~/type=\"compound\"/){
		  $line=~/name=\"(.+\d+)\" type/;
		  my @compound = split(/\s/,$1);
		  foreach my $c (@compound){
		    $node{$id}{$c}=1;
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
	}elsif($line=~/relation entry1=\"(\d+)\" entry2=\"(\d+)\" type=\"PPrel\"/){
	  #print("$lineNum\n");
		my $id1=$1;
		my $id2=$2;
		my @relType;
		my $tmp=<IN>;
		#print "$tmp\n";
		my $flag=0;
		while(not $tmp=~/\<\/relation\>/){
			if($tmp=~/subtype name=\"(.+)\" value=\"(.+)\"/){
				push(@relType,"$1^with^$2");
				if($1 eq "indirect effect"){
				  $flag=1;
				#}elsif($1 eq "compound"){
				#  $flag=1;
				#}else{
				  $checkRel{$1}=1;
				}
				#print "$id1 -> $id2\t$1\t$2\n";
			}
			$tmp=<IN>;
			#print "$tmp\n";
		}
		if($flag == 0){
		  $link{$id1}{$id2}=join("\t",@relType);
		}
	}elsif($line=~/relation entry1=\"(\d+)\" entry2=\"(\d+)\" type=\"PCrel\"/){
	  #print("$lineNum\n");
		my $id1=$1;
		my $id2=$2;
		my @relType;
		my $tmp=<IN>;
		#print "$tmp\n";
		my $flag=0;
		while(not $tmp=~/\<\/relation\>/){
			if($tmp=~/subtype name=\"(.+)\" value=\"(.+)\"/){
				push(@relType,"$1^with^$2");
				if($1 eq "indirect effect"){
				  $flag=1;
				#}elsif($1 eq "compound"){
				#  $flag=1;
				#}else{
				  $checkRel{$1}=1;
				}
				#print "$id1 -> $id2\t$1\t$2\n";
			}
			$tmp=<IN>;
			#print "$tmp\n";
		}
		if($flag == 0){
		  $link{$id1}{$id2}=join("\t",@relType);
		}
	}
}
close IN;


my %tree; #store the combination of different group members
foreach my $id2 (sort keys %node){ #$id2 is the entry id used in each of the kgml file
  if(exists $node{$id2}{"group"}){
    my $n=0; # record the number of groups
    #print("Group: $id2\n");
    foreach my $id22 (sort keys %{$node{$id2}{"group"}}){
      #print("   Entry: $id22\n");
      $n++;
      if(exists $node{$id22}{"group"}){
              print "Deeper group structure detected. Group id: $id2 -> $id22\n";
      }
      #presume the groups do not contain other groups as components
      # the members in a group should be assembled into a complex
      if($n == 1){
              #print("    \$n:$n\t$id22\n");
              foreach my $g2 (sort keys %{$node{$id22}}){
                      #print OUT "$g1\t$g2\t$link{$id1}{$id2}\n";
                      $tree{$id2}{$g2}=1;
              }
      }else{
              #print("    \$n:$n\t$id22\n");
              foreach my $g2 (sort keys %{$node{$id22}}){ # it is possible that multiple genes of one family is one subunit of an complex. For example, complex A+(B/C)+D will be split into ABD and ACD
                      foreach my $tmpC (sort keys %{$tree{$id2}}){ # $tmpC is the complex name, consisted of the names of the subunits, separated by "_"
                              if($tree{$id2}{$tmpC} == $n-1){ #meaning this combination needs to be extended
                                      my @vecC = split(/\_/,$tmpC);
                                      push(@vecC,$g2);
                                      @vecC=sort @vecC;#sort the genes to remove redundant combinations
                                      my $new = join("_",@vecC);
                                      #if($n ==3 ){
                                        #print("    new:$new\n");
                                      #}
                                      $tree{$id2}{$new}=$n;
                              }
                      }
              }
      }
    }
    foreach my $tmpC (sort keys %{$tree{$id2}}){
      if($tree{$id2}{$tmpC} < $n){
        delete $tree{$id2}{$tmpC};
      }
    }
  }
}

#output the group info for complex analysis in R script
foreach my $id2 (sort keys %tree){
  if(exists $tree{$id2}){
    foreach my $cplx (sort keys %{$tree{$id2}}){
      my @vec=split("_",$cplx);
      if(@vec == 1){
        print "Only one component exists in group $id2, possible a homodimer, ignored\n";
      }else{
        foreach my $subunit (@vec){
          print GRP "$subunit\t$cplx\n";
        }
      }
    }
  }else{
    print "Warning: void group id: $id2\n";
  }
}
close GRP;

#foreach my $id2 (sort keys %tree){
#  print("$id2\n");
#  foreach my $tmpC (sort keys %{$tree{$id2}}){
#    print("$id2:$tmpC\n");
#  }
#}


foreach my $id1 (sort keys %link){
	if(not exists $node{$id1}){
		print "Node1 id not found in the node list: $id1\n";
		next;
	}
	foreach my $id2 (sort keys %{$link{$id1}}){
		if(not exists $node{$id2}){
			print "Node2 id not found in the node list: $id2\n";
			next;
		}
		if(not exists $node{$id1}{"group"}){
			foreach my $g1 (sort keys %{$node{$id1}}){
				if(not exists $node{$id2}{"group"}){
					foreach my $g2 (sort keys %{$node{$id2}}){
						print OUT "$g1\t$g2\t$link{$id1}{$id2}\n";
					}
				}else{
					#Each group contains several entries, and each entry may include several genes. The genes in one single entry do not interact with each other, but can bind to the genes in the other entries
					#Therefore, we have to record all the combinations of the genes from different entries
					foreach my $tmpC (sort keys %{$tree{$id2}}){
					  print OUT "$g1\t$tmpC\t$link{$id1}{$id2}\n";
					}
			  }
		  }
		}else{ #$id1 is a Group
		  foreach my $tmpC1 (sort keys %{$tree{$id1}}){
		    if(not exists $node{$id2}{"group"}){ #$id2 is not a group
					foreach my $g2 (sort keys %{$node{$id2}}){
						print OUT "$tmpC1\t$g2\t$link{$id1}{$id2}\n";
					}
				}else{ #id2 is a group
					#Each group contains several entries, and each entry may include several genes. The genes in one single entry do not interact with each other, but can bind to the genes in the other entries
					#Therefore, we have to record all the combinations of the genes from different entries
					foreach my $tmpC2 (sort keys %{$tree{$id2}}){
					  print OUT "$tmpC1\t$tmpC2\t$link{$id1}{$id2}\n";
					}
			  }
		  }
			#foreach my $id11 (sort keys %{$node{$id1}{"group"}}){
			#	if(exists $node{$id11}{"group"}){
			#		print "Deeper group structure detected. Group id: $id1 -> $id11\n";
			#	}
			#	my $tmpGroup1 = join("_",sort keys %{$node{$
			#	foreach my $g1 (sort keys %{$node{$id11}}){
			#		if(not exists $node{$id2}{"group"}){
			#			foreach my $g2 (sort keys %{$node{$id2}}){
			#				print OUT "$g1\t$g2\t$link{$id1}{$id2}\n";
			#			}
			#		}else{
			#			foreach my $id22 (sort keys %{$node{$id2}{"group"}}){
			#				#presume the groups do not contain other groups as components
			#				foreach my $g2 (sort keys %{$node{$id22}}){
			#					print OUT "$g1\t$g2\t$link{$id1}{$id2}\n";
			#				}	
			#			}
			#		}
			#	}
			#}
		}
	}
}
close OUT;

#foreach my $check (sort keys %checkRel){
#  print("$check\n");
#}
