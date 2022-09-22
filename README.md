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

### The basic structure of the GIN files
The structure of the GIN files is composed of three columns:</br>
<img width="306" alt="image" src="https://user-images.githubusercontent.com/50654825/191729864-52fad977-19c3-488d-afdc-b5a80d01db23.png">
</br>
It's similar to the edge lists where the first column is the starting node of an edge, the second column is the ending node of the edge, the third column is the type of the edge. This simple structure makes it easy to be imported in various topology tools such as igraph and cytoscape.
</br>
Genes in the GIN files use NCBI's gene ID as their identifiers, and compounds use the KEGG's compound ids ("cpd:XXX"). 
</br>
