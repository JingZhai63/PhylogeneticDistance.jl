function getLabel(args...;Tree::Array{SubString{ASCIIString},1}=[],
	Start::Int =Int[],
	stop_char::Array{ASCIIString,1}=[])

    label = String[]
	u = 0
	while Tree[u+Start] in stop_char ==false
		u=u+1
		label = join(Tree[[0:1:(u-1)]+Start])
	end
    labelStart = (label,u+Start)
	labelStart = Dict(zip(["label","end"], labelStart))
	return labelStart
end

