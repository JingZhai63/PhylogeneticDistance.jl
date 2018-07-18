#  ##############################################################
#  # GUniFrac: Generalized UniFrac distances for comparing microbial
#  #						communities.
#  # Reference: Jun Chen & Hongzhe (2012). Associating microbiome
#  # composition with environmental covariates using generalized
#  # UniFrac distances.
#  ###############################################################

function GUniFrac(args...; otuTableFile::String = "",
	phy = thetree, alpha::Array{Float64,1} = Float64[], VAW::Bool = false)

    if isRooted(phy = phy) == false
    	error("isRooted:wrongtpe\n", "# Rooted phylogenetic tree required!")
    end

    # read in otu count table
    if isempty(otuTableFile)
    	error("GUniFrac:NoOTUtables\n", "# need to provide OTU count file");
    else
    	otuTable = readdlm(otuTableFile,',')
    	otuTableMatrix = otuTable[2:end, 1:end]
    	otuTableMatrix = convert(Array{Float64, 2}, otuTableMatrix);
    end

    row_sum = sum(otuTableMatrix, 2)
    #row_sum[1:10,:]=0.0
    zeroIndex = vec(row_sum[:,1]).==0.0
    otu_tab = otuTableMatrix
    otu_tab[zeroIndex.==false, :] = otuTableMatrix[zeroIndex .== false, :] ./ row_sum[zeroIndex.==false,:]
    otu_tab[zeroIndex.==true, :] = 0.0
    n = size(otu_tab)[1] # nrows

    # Construct the returning array
    # d_UW: unweighted UniFrac, d_VAW: weighted UniFrac
    function unifracArray(arg...)
    	unifracTuple = Array{Float64}(n, n)
    	return unifracTuple
    end
    if VAW == true
        unifracs = ntuple(unifracArray::Function,length(alpha)+2);
    else
        unifracs = ntuple(unifracArray::Function,length(alpha)+1);
    end

    nameList = Array{AbstractString}(length(alpha))
    for i = 1:length(alpha)
        nameList[i] = join(["d_", alpha[i]])
    end
    if VAW == true
        unifracs = Dict(zip(["d_UW","d_VAW", nameList], unifracs))
        fill!(unifracs["d_VAW"], 0.0)
    else
        unifracs = Dict(zip(["d_UW", nameList], unifracs))
    end


  	# Check OTU name consistency
    otuTableName = []
    for i=1:length(otuTable[1, 1:end])
        push!(otuTableName, AbstractString(otuTable[1,i]))
    end
    #otuNames = squeeze(convert(Array{ASCIIString,2},string(int(otuTable[1,1:end])),1)
    countIdex = 0
    otuNames = otuTableName
    for i =1 :length(otuNames)
    	if otuNames[i] in phy["tip_label"] ==false
    		countIdex = countIdex +1
    	end
    end

    if countIdex != 0
    	error("GUniFrac:moreOTU\n", "# The OTU table contains unknown OTUs! OTU names in the OTU table and the tree should match!")
    end

    # Get the subtree if tree contains more OTUs
##    tipIdex=Bool[]
##    for i = 1:length(phy["tip_label"])
##    	truefalse = phy["tip_label"][i] in otuNames
##        push!(tipIdex,truefalse)
##    end
##    countnz(tipIdex)
##    absent = phy["tip_label"][tipIdex.==false]

#    tip_label = phy["tip_label"]
#
#    absent = deleteat!(tip_label, findin(tip_label,otuNames))
#    if length(absent) != 0
#    	phy = DropTip(phy,absent)
#    	warn("The tree has more OTU than the OTU table!")
#    end

  	# Reorder the otu.tab matrix if the OTU orders are different
    tip_label = phy["tip_label"]

    reorderIdex = []
    for i = 1: length(tip_label)
     append!(reorderIdex,find(all(otuNames .== tip_label[i],2)))
    end
    otu_tab = otu_tab[:,reorderIdex]
    ntip = length(phy["tip_label"])
    nbr = size(phy["edge"])[1]
    edge = phy["edge"]
    edge2 = edge[:,2]
    br_len = phy["edge_length"]


 	#  Accumulate OTU proportions up the tree
    cum = Array{Float64}(nbr, n)    # Branch abundance matrix
    for i = 1:ntip
			inx = 1:length(edge2)
    	tip_loc = collect(1:length(edge2))[edge2 .== i][1]
    	cum[tip_loc:tip_loc, :] = cum[tip_loc:tip_loc, :] + transpose(otu_tab[:, i])
    	node = edge[tip_loc,1]      # Assume the direction of edge
			if countnz(edge2 .== node)==0
				node_loc = Int[]
			else
				node_loc = collect(1:length(edge2))[edge2 .== node][1]
			end
    	while length(node_loc)>0
    			cum[node_loc:node_loc, :] = cum[node_loc:node_loc,:] + transpose(otu_tab[:, i])
    			node = Int(edge[node_loc, 1])
					if countnz(edge2 .== node)==0
						node_loc = Int[]
					else
						node_loc = collect(1:length(edge2))[edge2 .== node][1]
					end
    	end
    end

  	# Calculate various UniFrac distances
   	cum_ct = round.((cum' .* row_sum)') 	# For VAW
    fill!(unifracs["d_UW"], 0.0)
    for k = 1:length(alpha)
        fill!(unifracs[[join(["d_",alpha[k]])]], 0.0)
    end

   	for i = 2:n
   		for j = 1:(i-1)
   			cum1 = cum[:, i]
   			cum2 = cum[:, j]
   			ind = []
            append!(ind,find(all(cum[:, i] + cum[:, j].>1e-10,2)))
            cum1 = cum1[ind]
            cum2 = cum2[ind]
            br_len2 = br_len[ind]
            mi = cum_ct[ind,i] + cum_ct[ind,j]
            mt = row_sum[i] + row_sum[j]
            diff = abs.((cum1 - cum2) ./ (cum1 +cum2))

            # Generalized UniFrac distance
            for k = 1:length(alpha)
                w = br_len2 .* (cum1 +cum2) .^ alpha[k]
            	#w = br_len2 .* (cum1 + cum2) ./ sqrt(mi .* (mt - mi))
            	unifracs[[join(["d_",alpha[k]])]][i,j] = unifracs[[join(["d_",alpha[k]])]][j,i] = sum(diff .* w) / sum(w)
            end

            # Variance Adjusted UniFrac Distance
            if VAW==true
                ind2 = []
                append!(ind2, find(all(mi .!= mt,2)))
                w = br_len2 .* (cum1 + cum2) ./ sqrt(mi .* (mt - mi))
                #w = br_len2 .* (cum1 +cum2) ^ alpha[k]
                unifracs["d_VAW"][i, j] = unifracs["d_VAW"][j,i] = sum(diff[ind2].*w[ind2])/sum(w[ind2])
            end
            # Unweighted UniFrac Distance
            ind3 = []
            ind4 = []
            append!(ind3, find(all(cum1 .>1e-10,2)))
            append!(ind4, find(all(cum2 .>1e-10,2)))
            cum1[ind3]=1
            cum2[ind4]=1
            unifracs["d_UW"][i, j] = unifracs["d_UW"][j,i] = sum(abs.(cum1-cum2)./(cum1+cum2) .* br_len2)/ sum(br_len2)
#            unifracs["d_UW"][i, i] = 0.0
        end
        unifracs["d_UW"][isnan.(unifracs["d_UW"])]=0.0
        for k = 1:length(alpha)
            unifracs[[join(["d_",alpha[k]])]][isnan.(unifracs[[join(["d_",alpha[k]])]])] = 0.0
        end
        if VAW == true
            unifracs["d_VAW"][isnan.(unifracs["d_VAW"])]=0.0
        end

    end
    return unifracs
end
