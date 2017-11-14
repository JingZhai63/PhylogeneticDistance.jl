
function isRooted(args...; phy = thetree)
	# if typeof(phy) != Phylo
	# 	 error("isRooted:wrongtpe\n", "# object phy is not class Phylo")
	# end
	if countmap(phy["edge"][:,1])[length(phy["tip_label"]) + 1] > 2
		false
	else true
	end
end
