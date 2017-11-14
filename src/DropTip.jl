
function DropTip(args...; phy::Phylo=tree,
    tip,
    trim_internal = true, subtree = false,
    root_edge::Int = 0,
    rooted = true, interactive = false)

    if isRooted(tree) == false
        error("isRooted:wrongtpe\n", "# Rooted phylogenetic tree required!")
    end
    Ntip = length(phy["tip_label"])
    if interactive == true
        xy = locator()
        nToDrop = length(xy["x"])
        tip = convert(Int, nToDrop)
        lastPP = get("last_plot.phylo", envir = PlotPhyloEnv)
        for i = 1:nToDrop
            d = sqrt(xy["x"][i]-lastPP["xx"]^2+(xy["y"][i]-lastPP["yy"])^2)
            tip[i] = indmin(d)
        end
    else
        if typeof(tip)==String
            tip = findin(phy["tip_label"],tip)
        end
    end

    out_of_range = []
    for i = 1:length(tip)
        push!(out_of_range, tip[i] > Ntip)
    end

    if any(out_of_range)
        warn("some tip numbers were larger than the number of tips: they were ignored")
        tip = tip[out_of_range .!=true]
    end
    if length(tip)==0
        return phy
    end
    if length(tip) == Ntip
        warn("drop all tips of the tree: returning NULL")
        return NULL
    end

    wbl = length(phy["edge_length"]) != 0
    if isRooted(tree) == false and subtree == false
        # phy = root(phy, (1:Ntip)[-tip][1])  # need to write the root function
        root_edge = 0
    end
    # phy = reorder(phy)
    NEWROOT = ROOT = Ntip + 1
    Nnode = phy["Nnode"]
    Nedge = size(phy["edge"])[1]
    if subtree == true
        trim_internal = true
        tr = reorder(phy, "postorder")
        N = ccall((:node_depth, "libc"), Array(Float64, 1),
            (Int, Int, Int, Int, Int, Int, Int),
            Ntip, Nnode, phy["edge"][:,1],phy["edge"][:,2],Nedge,
            convert(Array{Int64,1},zeros(Ntip+Nnode)),1)[6]
    end
    edge1 = phy["edge"][:,1]
    edge2 = phy["edge"][:,2]
    keep = trues(Nedge)
    mathidx = []
    for i = 1:length(edge2)
        if tip[i] == edge2[i]
            push!(mathidx, i)
        end
    end
    keep[mathidx] = false
    if trim_internal == true
        ints = []
        for i = 1:length(edge2)
            push!(ints, edge2[i] > Ntip)
        end
# need to add other options for subtree etc.
    end
end
