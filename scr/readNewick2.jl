

function readNewick(filepath::ASCIIString, format="nwk")
	instream = open(expanduser(filepath))
	instring = readall(instream)
	close(instream)
	trees = split(instring,"") 

    tip_label = String[];
    node_label = String[];

    tip_label = Array{ASCIIString,1};
    node_label = Array{Char,1};

      count1=0
      count2=0
      for i=1:length(trees)
    	if trees[i]=="("
            count1=count1+1
    	end
    	if trees[i]==","
    		count2=count2+1
    	end
      end
    edge = Array(Float64,count1 +count2,2)

    ei = Int[]
    edge.length = Array(Float64,1)

    currnode = 1
    Nnode = currnode
    i = j = k =1

    while trees[i]!=";"
    	if trees[i]=="("
    		edge[j,1] = currnode
    		i = i + 1
    		# is the next element a label?

    		if trees[i] in ["(",")",",",":",";"]==false
    			temp = getLable(Tree=trees, Start=i, stop_char=[",",":",")",";"])
                push!(tip_label, temp[1])
                i = temp[2]
                edge[j,2] = -k
                k = k+1
                # is there a branch length?
                if trees[i]==":"
                	temp = getEdgeLength(trees,i)
                	edge_length[j] = temp[1]
                	i = temp[2]
                end

            elseif trees[i] == "("
            	Nnode = Nnode + 1
            	currnode = Nnode
            	edge[j,2] = currnode	
            	push!(ei,currnode)
            end
            j = j + 1

        elseif trees[i]==")"
	            i = i + 1
	            # is the next element a label?
	            if trees[i] in ["(",")",",",":",";"] ==false
	            	temp = getLabel(Tree=trees, Start=i, stop_char=[",",":",")",";"])
                    push!(node_label,temp[1])
                    i = temp[2]
                end
                ii = ei[currnode]

                if trees[i]==":"
                	temp = getEdgeLength(trees,i)
                	if currnode >1 
                		edge_length[ii] = temp[1]
                	else root_edge = temp [1]
                	i = temp[2]
                end
                if currnode >1
                	currnode = edge[ii,i]
                end

        elseif trees[i]==","
        	edge[j,1] = currnode
        	i = i+1
        	if trees[i] in ["(",")",",",":",";"]==false
    			temp = getLable(Tree=trees, Start=i, stop_char=[",",":",")",";"])
                push!(tip_label, temp[1])
                i = temp[2]
                edge[j,2] = -k
                k = k+1
                # is there a branch length?
                if trees[i]==":"
                	temp = getEdgeLength(trees,i)
                	edge_length[j] = temp[1]
                	i = temp[2]
                end

            elseif trees[i]=="("
            	Nnode = Nnode + 1
            	currnode = Nnode
            	edge[j,2] = currnode
            	ei[currnode] = j
            end

            j = j + 1
        end

    end

Ntip = k - 1
tree = [edge, Nnode, tip_label, edge_length, node_label]

	return output_trees
end