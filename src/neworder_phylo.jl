

function neworder_phylo(args...; n::Int64=Int[], e1::Array{Int64, 1}=Int[], e2::Array{Int64, 1}=Int[],
	N::Int64=Int[], neworder::Array{Int64, 1}=Int[], order::Int64=Int[])
#   n: nb of tips
#   m: nb of nodes
#   N: nb of edges
#   degrmax is the largest value that a node degree can be

#* L is a 1-d array storing, for each node, it indices of the rows of
#  the edge matrix where the node is ancestor (i.e., present in the 1st
#  column). It is used in the same way than a matrix (which is actually
#  a vector) is used in R as a 2-d structure.
#* pos gives the position for each 'row' of L, that is the number of elements
#  which have already been stored for that 'row'.
    m = N - n + 1
    degrmax = n - m + 1

    L = zeros(Int, m * degrmax)
    pos = zeros(Int, m)

#* we now go down along the edge matrix
    for i = 1:N
    	k = e1[i] - n
    	j = pos[k]
    	pos[k] = pos[k] + 1
    	L[k + m * j] = i - 1
    end

#* L is now ready: we can start the recursive calls.
#* We start with the root 'n + 1':

    if order == 1
    	iii = 1
    	 foo_reorder(node=n+1,n=n,m=m,e1=e1,e2=e2,neworder=neworder,L=L,pos=pos)
    elseif order == 2
    	iii = N
    	bar_reorder(node=n+1,n=n,m=m,e1=e1,e2=e2,neworder=neworder,iii=iii,L=L,pos=pos)
    end
end
