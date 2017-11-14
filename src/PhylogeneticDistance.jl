module PhylogeneticDistance

import StatsBase
using StatsBase
import RCall
using RCall

export
       getLabel,
       getEdgeLength,
       readNewick,
       isRooted,
       GUniFrac,
       KernelMatrix

include("getLabel.jl")
include("getEdgeLength.jl")
include("readNewick.jl")
include("isRooted.jl")
include("GUniFrac.jl")
include("KernelMatrix.jl")
end
