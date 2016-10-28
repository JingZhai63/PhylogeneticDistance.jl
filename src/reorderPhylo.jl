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

#-------------------------------- R package "ape"-------------------------------#
#   
#   reorder.phylo <- function(x, order = "cladewise", index.only = FALSE, ...)
#   {
#       ORDER <- c("cladewise", "postorder", "pruningwise")
#       io <- pmatch(order, ORDER)
#       if (is.na(io)) stop("ambiguous order")
#       order <- ORDER[io]
#       nb.edge <- dim(x$edge)[1]
#       if (!is.null(attr(x, "order")))
#           if (attr(x, "order") == order)
#               if (index.only) return(1:nb.edge) else return(x)
#       nb.node <- x$Nnode
#       if (nb.node == 1)
#           if (index.only) return(1:nb.edge) else return(x)
#   
#       nb.tip <- length(x$tip.label)
#   
#       ## I'm adding the next check for badly conformed trees to avoid R
#       ## crashing (2013-05-17):
#       if (nb.node >= nb.tip)
#           stop("tree apparently badly conformed")
#   
#       if (io == 3) {
#           x <- reorder(x)
#           neworder <-
#               .C(neworder_pruningwise, as.integer(nb.tip),
#                  as.integer(nb.node), as.integer(x$edge[, 1]),
#                  as.integer(x$edge[, 2]), as.integer(nb.edge),
#                  integer(nb.edge))[[6]]
#       } else {
#           neworder <-
#               .C(neworder_phylo, as.integer(nb.tip),
#                  as.integer(x$edge[, 1]), as.integer(x$edge[, 2]),
#                  as.integer(nb.edge), integer(nb.edge), io,
#                  NAOK = TRUE)[[5]]
#       }
#       if (index.only) return(neworder)
#       x$edge <- x$edge[neworder, ]
#       if (!is.null(x$edge.length))
#           x$edge.length <- x$edge.length[neworder]
#       attr(x, "order") <- order
#       x
#   }

#   rotateConstr <- function(phy, constraint)
#   {
#       D <- match(phy$tip.label, constraint)
#       n <- Ntip(phy)
#   
#       P <- c(as.list(1:n), prop.part(phy))
#       e1 <- phy$edge[, 1L]
#       e2 <- phy$edge[, 2L]
#   
#       foo <- function(node) {
#           i <- which(e1 == node) # the edges where 'node' is ancestral
#           desc <- e2[i] # the descendants of 'node'
#           ## below, min() seems to work better than median() which
#           ## seems to work better than mean() which seems to work
#           ## better than sum()
#           o <- order(sapply(desc, function(x) min(D[P[[x]]])))
#           for (k in o) {
#               j <<- j + 1L
#               neworder[j] <<- i[k]
#               if ((dk <- desc[k]) > n) foo(dk)
#           }
#       }
#   
#       neworder <- integer(Nedge(phy))
#       j <- 0L
#       foo(n + 1L)
#       phy$edge <- phy$edge[neworder, ]
#       if (!is.null(phy$edge.length))
#           phy$edge.length <- phy$edge.length[neworder]
#       attr(phy, "order") <- "cladewise"
#       phy
#   }
