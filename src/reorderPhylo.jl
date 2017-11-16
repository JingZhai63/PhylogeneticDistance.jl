function reorderPhylo(args...; x = Phy,
    order::ASCIIString = "postorder", index_only = false)

    ORDER = ["cladewise", "postorder", "pruningwise"]
    io = [1:length(ORDER)][ORDER .== order]
    nb_edge = size(x["edge"])[1]

    if isempty(io)
        error("reorderPhylo: Wrong Order\n", "ambiguous order!")
    end

    if io == 1
        if index_only
            return [1:1:nb_edge]
        else
            return x
        end
    end

    nb_node = x["Nnode"]
    if nb_node == 1
        if index_only
            return [1:1:nb_edge]
        else
            return x
        end
    end

    nb_tip = length(x["tip_label"])
    if nb_node >= nb_tip
        error("reorderPhylo:badtree\n", "tree apparently badly conformed!")
    end

    if io == 3 # need to revise
        # x = reorder(x)
        # neworder = ccall((:neworder_pruningwise,"/Users/JINGZHAI/MkDocs/GitHub/phylogeneticTree/reorder_phylo.so"),
        #     RetType, (Int,Int,Array{Int64,1},Array{Int64,1},Int,Int), Int(nb_tip), Int(nb_node),Int(x["edge"][:,1],
        #         Int(x["edge"][:,2]),Int(nb_edge),Int(nb_edge))
    else
        neworder = zeros(Int, nb_edge)
        neworder = neworder_phylo(n=Int(nb_tip), e1=int(x["edge"][:,1]),
                 e2=int(x["edge"][:,2]), N=Int(nb_edge),
                 neworder=neworder,order=Int(io[1]))
    end

    if index_only
        return neworder
    else
        x["edge"] = x["edge"][neworder, :]

        if ! isempty(x["edge_length"])
            x["edge_length"] = x["edge"][neworder, :]
        end

        return x
    end
end
