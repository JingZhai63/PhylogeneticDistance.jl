function getEdgeLength(args...;Tree::Array{SubString{ASCIIString},1}=[],
	Start::Int =2)
	i = start + 1
	stop.char = [",",")",";"]
	while Tree[i] in stop_char ==false
		i=i+1
		edge.length = parse(join(tree[[(start+1):1:(i-1)]]))
	end
	return edge.length,i
end