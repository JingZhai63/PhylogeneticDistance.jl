function getLabel(args...; Tree::Array{SubString{String},1} = [],
	Start::Int = Int[], stop_char::Array{String,1} = [])

  label = String[]
	u = 0
	while countnz(Tree[u+Start] .== stop_char) == 0
		u = u + 1
		label = join(Tree[Start:(u - 1 + Start)])
	end
  labelStart = (label,u + Start)
	labelStart = Dict(zip(["label","end"], labelStart))
	return labelStart
end
