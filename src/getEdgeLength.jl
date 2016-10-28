function getEdgeLength(args...;Tree::Array{SubString{ASCIIString},1}=[],
	Start::Int =Int[])
	u = Start + 1
	stop_char = [",",")",";"]
    edge_length = Float64[]
	while Tree[i] in stop_char ==false
		u=u+1
		edge_length = parse(join(Tree[[(Start+1):1:(u-1)]]))
	end
	lengthStart = (edgelength,u+Start)
	lengthStart = Dict(zip(["edge_length","end"], lengthStart))
	return lengthStart 
end

