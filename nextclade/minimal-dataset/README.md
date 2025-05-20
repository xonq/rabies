# Example dataset for Rabies virus

This is a minimal example dataset for *Lyssavirus rabies*. 

# Phylogeny and clade assignment methodology

The phylogenetic tree was generated from all complete *Lyssavirus rabies* genomes obtained from [NCBI Nucleotide](https://ftp.ncbi.nlm.nih.gov/genomes/Viruses/AllNuclMetadata/) (accessed 2025/05/01). Clade, subclade, and other associated metadata were acquired referencing the original rabies Nextstrain build and [RABV-GLUE's metadata](https://github.com/giffordlabcvr/RABV-GLUE/blob/master/tabular/reference-set-data.tsv). Complete genome assemblies were aligned with `mafft v7.525` using default parameters and the phylogeny was reconstructed using `iqtree v2.4.0` with 1000 ultrafast bootstrap iterations and GTR+F+I+R7 selected as the evolutionary model by the *ModelFinder* module. A root node internal to the *L. rabies* phylogeny was selected by reconstructing an additional phylogeny using the same methodology with *L. australis* (NC_003243.1) and *L. gannoruwa* (KU244266.2) included as known outgroups ([Baynard & Fooks, 2021](https://www.sciencedirect.com/science/article/abs/pii/B9780128096338209369)).