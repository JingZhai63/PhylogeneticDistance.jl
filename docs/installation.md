# Installation

To install _PhylogeneticDistance.jl_, open up Julia and then type

```julia
julia> Pkg.update()
julia> Pkg.clone("https://github.com/JingZhai63/PhylogeneticDistance.jl.git")
```
If you do not have Julia package _StatsBase_ and _RCall_ installed, please install

```julia
julia> Pkg.add("StatsBase")
julia> Pkg.add("RCall")
```

Then you can use the following command to verify that the package has been installed successfully

```julia
julia> using PhylogeneticDistance
julia> KernelMatrix()
KernelMatrix (generic function with 1 method)
```
