module PhylogeneticDistance

import StatsBase
using StatsBase

export
       getLabel,
       getEdgeLength,
       readNewick,
       isRooted,
       GUniFrac
#       node_depth,
#       foo_reorder,
#       bar_reorder,
#       neworder_phylo,
#       reorderPhylo,
#       DropTip,
#       KernelMatrix

include("getLabel.jl")
include("getEdgeLength.jl")
include("readNewick.jl")
include("isRooted.jl")
include("GUniFrac.jl")

# include("node_depth.jl")
# include("foo_reorder.jl")
# include("bar_reorder.jl")
# include("neworder_phylo.jl")
# include("reorderPhylo.jl")
# include("DropTip.jl")
# include("KernelMatrix.jl")

end
