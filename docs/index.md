
# Phylogenetic Distance and Kernel Matrices for Microbiome Data
**PhylogeneticDistance.jl** is a Julia package for computing UniFrac distance matrices which measure the similarity of  microbiome taxonomic data among samples. We offer four types of UniFrac distance calculation from literatures:

* Unweighted UniFrac distance
* Weighted UniFrac distance  
* Variance adjusted weighted UniFrac distance
* General UniFrac distance  

The input files for _PhylogeneticDistance.jl_ are microbiome data `count table (.csv file)` and `tree file (.txt file)`. You should have these input files prepared before running our program. The `output files (.csv files)` is simple comma-delimited files, including UniFrac distance or transformed kernel matrices.

To use **PhylogeneticDistance.jl** , you need to call the `GUniFrac()` function.

Please see the detailed documents in [Read the Docs](http://phylogeneticdistancejl.readthedocs.io/en/latest/)

## Contents

* [Installation](http://phylogeneticdistancejl.readthedocs.io/en/latest/installation/)
* [Dataformats](http://phylogeneticdistancejl.readthedocs.io/en/latest/dataformats/)
* [Usage](http://phylogeneticdistancejl.readthedocs.io/en/latest/usage/)
* [Examples](http://phylogeneticdistancejl.readthedocs.io/en/latest/examples/)
