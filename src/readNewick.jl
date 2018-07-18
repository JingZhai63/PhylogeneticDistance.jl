
function readNewick(args...; filepath::String = "", format::String = "nwk")
    # read in the string of tree file
    instream = open(expanduser(filepath));
    instring = readstring(instream);
    close(instream);
    trees = split(instring,"");  # split the each element of the tree string
    trees = trees[trees.!="\r"];
    trees = trees[trees.!="\n"];

    # calculate the sum of "(" and "," in the tree in order to set up the edge dimension
      count1 = 0
      count2 = 0
      for i = 1:length(trees)
        if trees[i] == "("
            count1 = count1 + 1
        end
        if trees[i] == ","
            count2 = count2 + 1
        end
      end

    edge = Array{Float64}(count1 + count2, 2);
    node_label = Array{String}(count1, 1); # generate empty node_label vector
    tip_label = String[];  # generate empty tip_label vector

    #ei = Float64[]
    edge_length = Array{Float64}(count1 + count2, 1);
    ei = Array{Int64}(count1+1, 1);
   # edge_length = Array(Float64,1)

    currnode = 1;
    Nnode = currnode;
    i = j = k = 1;

#   while trees[i]!=";"
    for i = 1:(size(trees)[1] - 1)
        if trees[i] == "("
            edge[j, 1] = currnode
            i = i + 1

            # is the next element a label?
            if countnz(trees[i] .== ["("; ")"; ","; ":"; ";"]) == 0
                temp = getLabel(Tree = trees, Start = i, stop_char = [","; ":"; ")"; ";"])
                #btip_label[k] = temp["label"]
                push!(tip_label, temp["label"])
                i = temp["end"]
                edge[j,2] = -k
                k = k + 1
                # is there a branch length?
                if trees[i] == ":"
                    temp = getEdgeLength(Tree = trees, Start = i)
                    edge_length[j] = temp["edge_length"]
                    #push!(edge_length,temp["edge_length"])
                    i = temp["end"]
                end
               # push!(ei,NaN)

            elseif trees[i] == "("
                Nnode = Nnode + 1
                currnode = Nnode
                edge[j, 2] = currnode
                #push!(ei,currnode)
                ei[currnode] = j
            end
            j = j + 1

        elseif trees[i] == ")"
                i = i + 1
                # is the next element a label?
                if countnz(trees[i] .== ["("; ")"; ","; ":"; ";"]) == 0
                    temp = getLabel(Tree = trees, Start = i, stop_char = [","; ":"; ")"; ";"])
                    node_label[currnode] = temp["label"]
                    i = temp["end"]
                end
                ii = Int(ei[currnode])

                if trees[i] == ":"
                    temp = getEdgeLength(Tree = trees, Start = i)
                    if currnode >1
                         edge_length[ii] = temp["edge_length"]
                        #push!(edge_length,temp["edge_length"])
                    else
                        root_edge = temp["edge_length"]
                        i = temp["end"]
                    end
                end
                if currnode > 1
                    currnode = Int(edge[ii, 1])
                end

        elseif trees[i] == ","
            edge[j, 1] = currnode
            i = i + 1
            if countnz(trees[i] .== ["("; ")"; ","; ":"; ";"]) == 0
                temp = getLabel(Tree = trees, Start = i, stop_char = [","; ":"; ")"; ";"])
                push!(tip_label, temp["label"])
                i = temp["end"]
                edge[j, 2] = -k
                k = k + 1
                # is there a branch length?
                if trees[i] == ":"
                    temp = getEdgeLength(Tree = trees, Start = i)
                    edge_length[j] = temp["edge_length"]
                   # push!(edge_length,temp["edge_length"])

                    i = temp["end"]
                end

            elseif trees[i] == "("
                Nnode = Nnode + 1
                currnode = Nnode
                edge[j, 2] = currnode
                #push!(ei,j)
                 ei[currnode] = j
            end
            j = j + 1
        end

    end

    Ntip = k - 1
    temInd = edge[:,:] .> 0
    edge[temInd[:, 2], 2] = edge[temInd[:, 2], 2] .+ Ntip
    edge[temInd[:, 1], 1] = edge[temInd[:, 1], 1] .+ Ntip
    edge = abs.(edge)

    tree = ((edge), (Nnode), (tip_label), (edge_length), (node_label))
    tree  = Dict(zip(["edge", "Nnode", "tip_label", "edge_length", "node_label"], tree))
    return tree
end
