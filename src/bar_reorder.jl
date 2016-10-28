
function bar_reorder(args...; node::Int64=Int[], n::Int64=Int[],m::Int64=Int[], 
    e1::Array{Int64, 1}=Int[], e2::Array{Int64, 1}=Int[],
    neworder::Array{Int64, 1}=Int[], iii::Int64=Int[],
    L::Array{Int64, 1}=Int[], pos::Array{Int64, 1}=Int[])
    
    for i  = 1:length(pos) #1
        for u = 1:pos[i]
            j = pos[i] - 1
            while j >= 0
                neworder[iii] = L[i+m*j] + 1
                iii=iii-1
                j = j - 1  # ????
            end
            k = e2[L[i+m*(u-1)]+1]
            if k <= n 
                break
            else 
                break
            end
        end
    end
    return neworder
end

#  function bar_reorder(args...; node::Int64=Int[], n::Int64=Int[],m::Int64=Int[], 
#  	e1::Array{Int64, 1}=Int[], e2::Array{Int64, 1}=Int[],
#  	neworder::Array{Int64, 1}=Int[], iii::Int64=Int[],
#      L::Array{Int64, 1}=Int[], pos::Array{Int64, 1}=Int[], neworder2::Array{Int64, 1}=Int[],
#      j::Array{Int64, 1}=Int[],k::Array{Int64, 1}=Int[],i::Array{Int64, 1}=Int[])
#      
#      i  = node - n #1
#      j = pos[i] - 1

#      while j >= 0
#      	neworder[iii] = L[i+m*j] + 1
#      	iii=iii-1
#      	j = j - 1  # ????
#      end
#      neworder
#  
#      for j = 1:pos[i]
#      	k = e2[L[i+m*(j-1)]+1]
#      	if k > n
#      	   #bar_reorder(node=k,n=n,m=m,e1=e1,e2=e2,neworder=neworder,iii=iii,L=L,pos=pos,neworder2=neworder2)
#      	end
#      end
#      return neworder2
#  end
