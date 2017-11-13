module PhylogeneticDistance

import StatsBase

export
       readNewick,
       getLabel,
       getEdgeLength,
       node_depth,
       foo_reorder,
       bar_reorder,
       neworder_phylo,
       reorderPhylo,
       DropTip,
       isRooted,
       GUniFrac,
       KernelMatrix

include("readNewick.jl")
include("getLabel.jl")
include("getEdgeLength.jl")
include("node_depth.jl")
include("foo_reorder.jl")
include("bar_reorder.jl")
include("neworder_phylo.jl")
include("reorderPhylo.jl")
include("DropTip.jl")
include("GUniFrac.jl")
include("KernelMatrix.jl")

end