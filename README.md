# GIN
Global Integrative Network, for integration of signaling and metabolic pathways

## General introduction
The basic layout of the signaling and metabolic pathways were uniformed into the structure similar to chemical reactions：
<img width="848" alt="image" src="https://user-images.githubusercontent.com/50654825/173787625-a46ac547-907e-4490-9129-b5f5635f3c35.png"><br>
Figure 1. The conversion of metabolic and signaling pathways to meta-pathways. **a** A metabolic reaction is split into four types of relations, _1_. the subunits to the enzyme, _2_. The enzyme participating the formation of the intermediate, _3_. The substrate participating the formation of the intermediate, and _4_. The generation of the product from the intermediate. **b** A signaling reaction is also split into the four similar types of relations. Just note that the substrate and the product of a signaling reaction is usually displayed as the same node since the changes only take place in the subgroups of the molecules. **c** Merging of signaling and metabolic meta-pathways retains the connectivity of metabolic enzymes to the reactions they catalyze.
</br>

## The resulting GIN files
### The availability of the GIN files
The GINs of human(hsa), mouse(mmu), arabidopsis(ath) and rice(osa) can be found in the folder "GINs_four_species". The relations extracted from "PPrel" and "PCrel" were stored in the "*.pprel.*" files, while the relations extracted from "reactions" were stored in "*.reaction.*" files. We have compiled 7077 species based on KEGG database. The other GIN files are freely available upon request to the [maintainer](chix@big.ac.cn)<br>
To merge the signaling and metabolic meta-pathways, simply use "cat" command to concatenate them and then remove the redundancies:
```
cat relations.pprel.hsa.txt relations.reaction.hsa.txt > gin.hsa.tmp
cat gin.hsa.tmp > sort |uniq > gin.hsa.txt
rm gin.hsa.tmp
```

### The basic structure of the GIN files
The structure of the GIN files is composed of three columns:</br>
<img width="306" alt="image" src="https://user-images.githubusercontent.com/50654825/191729864-52fad977-19c3-488d-afdc-b5a80d01db23.png">
</br>
It's similar to the edge lists where the first column is the starting node of an edge, the second column is the ending node of the edge, the third column is the type of the edge. The ";" seperates the substrates and enzymes in an intermediate, therefore, the presence of ";" in the name means that this node is an intermediate. This feature is useful when one is trying to interprete the network or to simplify a subset of the network. The "*_*" separate the subunits of a large molecule. When there are alternatives of the subunits (for example, the histones), we would create nodes for every possible combinations of the subunits, so that each node in the network only represent one particular molecule. 
</br>
The four types of the edges are defined as they are in Figure 1, with special cases for type4 when the reactions result in the inhibition of the biological functions of the product, then the type4 relations will be written as "type4-inhibition". 
### ID conversions
Genes in the GIN files use NCBI's gene ID as their identifiers, and compounds use the KEGG's compound ids ("cpd:XXX"). To convert NCBI's gene ID to other types of identifiers (gene symbol, ensembl gene id etc.), one can follow the instructions [here](https://github.com/RenGroup/ibNN/blob/main/id_conversion/README_idConversion.md) . It provides tips on how to obtain the daily-updated official id mapping files from NCBI's ftp. 
</br>
To convert the compound ids to other types of ids, one can investigate the R package [KEGGREST](https://bioconductor.org/packages/release/bioc/html/KEGGREST.html), especially the "keggGet" function. Of course, this package also offers a solution to map the gene ids to other gene identifiers. 
