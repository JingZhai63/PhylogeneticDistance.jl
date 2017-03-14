function getEdgeLength(args...;Tree::Array{SubString{String},1}=[],
	Start::Int =Int[])
	u = Start + 1
	stop_char = [",",")",";"]
  edge_length = Float64[]
	while countnz(Tree[u] .== stop_char) ==0
		u=u+1
		edge_length = parse(join(Tree[(Start+1):(u-1)]))
	end
	lengthStart = (edge_length,u+Start)
	lengthStart = Dict(zip(["edge_length","end"], lengthStart))
	return lengthStart
end
