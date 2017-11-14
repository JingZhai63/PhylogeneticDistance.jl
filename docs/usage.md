<style TYPE="text/css">
code.has-jax {font: inherit; font-size: 100%; background: inherit; border: inherit;}
</style>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    tex2jax: {
        inlineMath: [['$','$'], ['\\(','\\)']],
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'] // removed 'code' entry
    }
});
MathJax.Hub.Queue(function() {
    var all = MathJax.Hub.getAllJax(), i;
    for(i = 0; i < all.length; i += 1) {
        all[i].SourceElement().parentNode.className += ' has-jax';
    }
});
</script>
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

# Usage
The core function in package _PhylogeneticDistance.jl_ is KernelMatrix(), which construct the UniFrac distance matrix or its positive definite kernel matrix. The usage for KernelMatrix() is
```julia
KernelMatrix(Name=Value)
```
Where `Name` is the option name and `Value` is the value of the corresponding option. Note that it's okay if some of the `Value` is not provided since all of the options have a default value.

There are two ways to call _KernelMatrix()_

* Open up Julia and type
```julia
julia> using PhylogeneticDistance
julia> KernelMatrix(Name = Value)
```
* From command line, type
```command
$ julia -E 'using PhylogeneticDistance; KernelMatrix(Name = Value)'
```

# Background
UniFrac is a distance metric used for comparing biological communities. It differs from dissimilarity measures such as Bray-Curtis dissimilarity in that it incorporates information on the relative relatedness of community members by incorporating phylogenetic distances between observed organisms in the computation. Both weighted (quantitative) and unweighted (qualitative) variants of UniFrac are widely used in microbial ecology, where the former accounts for abundance of observed organisms, while the latter only considers their presence or absence. The method was devised by Catherine Lozupone, when she was working under Rob Knight of the University of Colorado at Boulder in 2005.

In 2012, a generalized UniFrac version, which unifies the weighted and unweighted UniFrac distance in a single framework, was proposed by Chen _et al_. The weighted and unweighted UniFrac distance place too much weight on either abundant lineages or rare lineages. Their power to detect environmental influence is limited under some setting, where the moderately abundant lineages are mostly affected. The generalized UniFrac distance corrects the limitation of the weighted/weighted UniFrac distance by down-weighting their emphasis on either abundant or rare lineages.

Kernel matrix is a positive definite matrix transformed from the UniFrac distance matrix using

$\bf{K} = -\dfrac{1}{2}(\bf{I}-\dfrac{11'}{n}\bf{D^2}\dfrac{11'}{n})$

# Specify path and file name for count table

Option `tableFile` indicates the file name for the input microbiome count table. The /PATH/TO/FILE need to be specified if the file is not in working directory.

```julia
KernelMatrix(tableFile = "count.csv")
KernelMatrix(tableFile = "/PATH/TO/count.csv")
```

# Specify input tree file name

Option `treeFile` indicates the file name for the input microbiome phylogenetic tree file. The /PATH/TO/FILE need to be specified if the file is not in working directory.

```julia
KernelMatrix(treeFile = "tree.txt")
KernelMatrix(treeFile = "/PATH/TO/tree.txt")
```

The default format for tree file is "nwk". More tree type will be implement in the future.

# Specify type of UniFrac distance

Option `Dtype` indicates the distance type of UniFrac. The default is "d_UW" which is the unweighted UniFrac. Option `alpha` indicates the parameter of the generalized UniFrac distance. The default of `alpha` is _1.0_, which is the weighted UniFrac. `alpha` can be any number in [0, 1].
```julia
KernelMatrix(Dtype = "d_alpha", alpha = 0.5)
KernelMatrix(Dtype = "d_UW")
KernelMatrix(Dtype = "d_VAW")
```


# Choose the output type

Option `Kernel` indicates the `KernelMatrix` will output kernel matrix instead of distance matrix. The default is true since the following microbiome data analysis utilizes the kernel function.
```julia
KernelMatrix(Kernel = true, frobenius = true)
```

# Specify the output file name

Option `out` add name to the output file (optional). For example,
```julia
KernelMatrix(out = "microbiome")
```
