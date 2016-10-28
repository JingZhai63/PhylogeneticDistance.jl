

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

#-------------------------------- R package C function-------------------------------#

# void node_depth(int *ntip, int *nnode, int *e1, int *e2,
#         int *nedge, double *xx, int *method)
# /* method == 1: the node depths are proportional to the number of tips
#    method == 2: the node depths are evenly spaced */
# {
#     int i;
# 
#     /* First set the coordinates for all tips */
#     for (i = 0; i < *ntip; i++) xx[i] = 1;
# 
#     /* Then compute recursively for the nodes; we assume `xx' has */
#     /* been initialized with 0's which is true if it has been */
#     /* created in R (the tree must be in pruningwise order) */
#     if (*method == 1) {
#     for (i = 0; i < *nedge; i++)
#         xx[e1[i] - 1] = xx[e1[i] - 1] + xx[e2[i] - 1];
#     } else { /* *method == 2 */
#     for (i = 0; i < *nedge; i++) {
#         /* if a value > 0 has already been assigned to the ancestor
#            node of this edge, check that the descendant node is not
#            at the same level or more */
#         if (xx[e1[i] - 1])
#         if (xx[e1[i] - 1] >= xx[e2[i] - 1] + 1) continue;
#         xx[e1[i] - 1] = xx[e2[i] - 1] + 1;
#     }
#     }
# }