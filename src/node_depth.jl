

function node_depth(args...;ntip::Int=Int[], nnode::Int=Int[],
    e1::Array{Int64,1}=Int[],e2::Array{Int64,1}=Int[], nedge::Int=Int[],method::Int=Int[],xx::Array{Int64,1}=Int[])

    for i in 1:ntip
        xx[i] = 1
    end

    if method == 1
        for i in 1:nedge
            xx[e1[i]] = xx[e1[i]] + xx[e2[i]]
        end
    elseif method == 2
        for i in 1:nedge
            if (xx[e1[i]] != 0)
                if xx[e1[i]] >=xx[e1[i]] + 1
                    continue
                end
                xx[ei[i]] = xx[e2[i]] + 1
            end
        end
    end
    return xx
end
