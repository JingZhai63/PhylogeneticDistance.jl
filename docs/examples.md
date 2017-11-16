# Examples

This example illustrates the usages of different options by analyzing a simulated microbiome count data set and phylogenetic tree file obtained from a longitudinal HIV Pulmonary Microbiome Study. This phylogenetic tree contains 2964 OTU. Here, we use genus _Actinomyces_ as an example. The required input files are

* count table: Actinomyces.csv
* phylogenetic tree: Actinomyces (plain txt in newick format)

These data files come with our package, and they are available at here.

# Basic usage

Open up a Julia session and type

* setting working directory
```julia
julia> cd("/PATH/TO/USERS/.julia/v0.6/PhylogeneticDistance/docs/examples")
```

* compute the psd kernel matrix in Frobenius unit
```julia
julia> using PhylogeneticDistance
julia> KernelMatrix(tableFile = "count/Actinomyces.csv", treeFile = "tree/Actinomyces")
```

You can also call _KernelMatrix_ from command line. For example, to perform selection,

```command
$ julia -E 'using PhylogeneticDistance; KernelMatrix(tableFile = "count/Actinomyces.csv", treeFile = "tree/Actinomyces")
```

Note:
* If the input files are not at the current directory, you should specify the paths correctly.
* If the you do not want scale kernel matrix in Frobenius unit
```julia
julia> using PhylogeneticDistance
julia> KernelMatrix(tableFile = "count/Actinomyces.csv", treeFile = "tree/Actinomyces", frobenius = false)
```
* We recommend to perform the transformation and psd correction to get the  kernel matrix, but users can choose to output distance matrix by
```julia
julia> using PhylogeneticDistance
julia> KernelMatrix(tableFile = "count/Actinomyces.csv", treeFile = "tree/Actinomyces", Kernel = false)
```
In this case, option `frobenius` doesn't matter if true or false.

# Option `Dtype`

User can choose which UniFrac distance to use,

For example, the unweighted UniFrac distance

```julia
julia> using PhylogeneticDistance
julia> KernelMatrix(tableFile = "count/Actinomyces.csv", treeFile = "tree/Actinomyces", Dtype = "d_UW")
```

or generalized UniFrac with parameter α = 0.5

```julia
julia> using PhylogeneticDistance
julia> KernelMatrix(tableFile = "count/Actinomyces.csv", treeFile = "tree/Actinomyces", Dtype = "d_alpha", alpha = 0.5)
```
