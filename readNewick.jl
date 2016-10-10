

# getLabel<-function(text,start,stop.char=c(",",":",")",";")){
#   i<-0
#   while(is.na(match(text[i+start],stop.char))) i<-i+1
#   label<-paste(text[0:(i-1)+start],collapse="")	
#   return(list(label=paste(label,collapse=""),end=i+start))
# }

function getLable(args...;Tree::Array{SubString{ASCIIString},1}=[],
	Start::Int =2,
	stop_char::Array{ASCIIString,1}=[])
	i = 0
	while Tree[i+start] in stop_char ==false
		i=i+1
		label = join(tree[[0:1:(i-1)]+Start])
	end
	return label,i+start
end

# getEdgeLength<-function(text,start){
#   i<-start+1
#   stop.char<-c(",",")",";")
#   while(is.na(match(text[i],stop.char))) i<-i+1
#   edge.length<-as.numeric(paste(text[(start+1):(i-1)],collapse=""))
#   return(list(edge.length=edge.length,end=i))
# }

function getEdgeLength(args...;Tree::Array{SubString{ASCIIString},1}=[],
	Start::Int =2)
	i = start + 1
	stop.char = [",",")",";"]
	while Tree[i] in stop_char ==false
		i=i+1
		edge.length = parse(join(tree[[(start+1):1:(i-1)]]))
	end
	return edge.length,i
end


function readNewick(filepath::ASCIIString, format="nwk")
	# text<-scan(file,sep="\n",what="character",...)
	instream = open(expanduser(filepath))
	instring = readall(instream)
	close(instream)
    # text<-unlist(strsplit(text, NULL))
	trees = split(instring,"") 
	# tip.label<-vector(mode="character")
    # node.label<-vector(mode="character")
    tip_label = String[];
    node_label = String[];

    tip_label = Array{ASCIIString,1};
    node_label = Array{Char,1};
    # edge<-matrix(NA,sum(text=="(")+sum(text==","),2)
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
    # ei<-vector()
    # edge.length<-vector()
    ei = Int[]
    edge.length = Array(Float64,1)
    # currnode<-1
    # Nnode<-currnode
    # i<-j<-k<-1 
    currnode = 1
    Nnode = currnode
    i = j = k =1

#   while(text[i]!=";"){
#     if(text[i]=="("){
#        edge[j,1]<-currnode
#        i<-i+1
    while trees[i]!=";"
    	if trees[i]=="("
    		edge[j,1] = currnode
    		i = i + 1
    		# is the next element a label?

#     # is the next element a label?
#     if(is.na(match(text[i],c("(",")",",",":",";")))){
#       temp<-getLabel(text,i)
#       tip.label[k]<-temp$label
#       i<-temp$end
#       edge[j,2]<--k
#       k<-k+1
#       # is there a branch length?
#       if(text[i]==":"){
#         temp<-getEdgeLength(text,i)
#         edge.length[j]<-temp$edge.length
#         i<-temp$end
#       }
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

#     } else if(text[i]=="("){
#       Nnode<-Nnode+1 # creating a new internal node
#       currnode<-Nnode
#       edge[j,2]<-currnode # move to new internal node
#       ei[currnode]<-j
#     }
#     j<-j+1
            elseif trees[i] == "("
            	Nnode = Nnode + 1
            	currnode = Nnode
            	edge[j,2] = currnode	
            	push!(ei,currnode)
            end
            j = j + 1
#   } else if(text[i]==")"){
#     i<-i+1
#     # is the next element a label?
#     if(is.na(match(text[i],c("(",")",",",":",";")))){
#       temp<-getLabel(text,i)
#       node.label[currnode]<-temp$label
#       i<-temp$end
#     }
#     ii<-ei[currnode]
        elseif trees[i]==")"
	            i = i + 1
	            # is the next element a label?
	            if trees[i] in ["(",")",",",":",";"] ==false
	            	temp = getLabel(Tree=trees, Start=i, stop_char=[",",":",")",";"])
                    push!(node_label,temp[1])
                    i = temp[2]
                end
                ii = ei[currnode]
#     # is there a branch length?
#     if(text[i]==":"){
#       temp<-getEdgeLength(text,i)
#       if(currnode>1) edge.length[ii]<-temp$edge.length
#       else root.edge<-temp$edge.length
#       i<-temp$end
#     }	
#     if(currnode>1) currnode<-edge[ii,1] # move down the tree	`

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
#   } else if(text[i]==","){
#     edge[j,1]<-currnode
#     i<-i+1
#     # is the next element a label?
#     if(is.na(match(text[i],c("(",")",",",":",";")))){
#       temp<-getLabel(text,i)
#       tip.label[k]<-temp$label
#       i<-temp$end
#       edge[j,2]<--k
#       k<-k+1
#       # is there a branch length?
#       if(text[i]==":"){
#         temp<-getEdgeLength(text,i)
#         edge.length[j]<-temp$edge.length
#         i<-temp$end
#       }
#     } else if(text[i]=="("){
#       Nnode<-Nnode+1 # creating a new internal node
#       currnode<-Nnode
#       edge[j,2]<-currnode # move to internal node
#       ei[currnode]<-j
#     }
#     j<-j+1
#   }
# }
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
# Ntip<-k-1
# edge<-edge[!is.na(edge[,2]),,drop=F]
# edge[edge>0]<-edge[edge>0]+Ntip
# edge[edge<0]<--edge[edge<0]
# edge.length[is.na(edge.length)]<-0
# if(length(edge.length)==0) edge.length<-NULL
# node.label[is.na(node.label)]<-""
# if(length(node.label)==0) node.label<-NULL
# # assemble into "phylo" object
# tree<-list(edge=edge,Nnode=as.integer(Nnode),tip.label=tip.label,edge.length=edge.length,node.label=node.label)
# class(tree)<-"phylo"
# attr(tree,"order")<-"cladewise"
# return(tree)
#}

Ntip = k - 1
tree = [edge, Nnode, tip_label, edge_length, node_label]

	return output_trees
end