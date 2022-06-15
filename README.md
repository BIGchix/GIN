# GIN
Global Integrative Network, for integration of signaling and metabolic pathways

The basic layout of the signaling and metabolic pathways were uniformed into the structure similar to chemical reactions：
<img width="848" alt="image" src="https://user-images.githubusercontent.com/50654825/173787625-a46ac547-907e-4490-9129-b5f5635f3c35.png"><br>
To parse the KEGG kgml files representing signaling and metabolic pathways, we built a R package based upon the KEGGREST API. The package requires KEGGREST which can be installed by:<br>
<code>if (!require("BiocManager", quietly = TRUE))<br></code>
<code>    install.packages("BiocManager")<br></code>
<code>BiocManager::install("KEGGREST")</code><br>
