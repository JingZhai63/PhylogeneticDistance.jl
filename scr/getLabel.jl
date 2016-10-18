function getLabel(args...;Tree::Array{SubString{ASCIIString},1}=[],
	Start::Int =2,
	stop_char::Array{ASCIIString,1}=[])
	i = 0
	while Tree[i+start] in stop_char ==false
		i=i+1
		label = join(tree[[0:1:(i-1)]+Start])
	end
	return label,i+start
end