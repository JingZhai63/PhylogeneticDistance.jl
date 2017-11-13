
function foo_reorder(args...; node::Int64=Int[], n::Int64=Int[],m::Int64=Int[], 
    e1::Array{Int64, 1}=Int[], e2::Array{Int64, 1}=Int[],
    neworder::Array{Int64, 1}=Int[], L::Array{Int64, 1}=Int[], pos::Array{Int64, 1}=Int[])
    i  = node - n 
    for j in 1:pos[i]
        k = L[i + m*j]
        neworder[iii] = k + 1
        if e2[k] > n
            foo_reorder(node=e2[k],n=n,m=m,e1=e1,e2=e2,neworder=neworder,L=L,pos=pos)
        end
        iii = iii + 1
    end
end
