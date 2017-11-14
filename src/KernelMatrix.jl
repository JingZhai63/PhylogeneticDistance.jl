using RCall

R"require(OpenMx)"
R"ToPSD <- function(distance, frobenius = FALSE){
  DistanceMatrix <- as.matrix(distance)
  N <- dim(DistanceMatrix)[1]
  D2 <- DistanceMatrix^2
  I <- diag(N)
  one <- as.matrix(rep(1, N))
  one.t <- t(one)
  K <- -0.5*(I - one %*% one.t/N) %*% D2 %*% (I - one%*%one.t/N)
	if (frobenius){
  	f = norm(K, type = 'F')
  	K = K/f
  }
  evecK = as.matrix(eigen(K)$vector)
  evalK = as.vector(abs(eigen(K)$values))
  evalK[evalK < 1e-4] = 1e-4
  diagK = vec2diag(evalK)
  psdK = evecK %*% diagK %*% t(evecK)
  return(psdK)
}"


function KernelMatrix(arg...; tableFile::String = "", treeFile::String = "",
  out::String = "", format::String = "nwk", alpha::Array{Float64,1} = 1.0,
  Dtype::String = "d_UW", Kernel::Bool = true, frobenius::Bool = true)

  tree = readNewick(filepath = treeFile, format = format)
  if Dtype = "d_VAW"
    VAW = true
  else
    VAW = false
  end

  Distance = GUniFrac(otuTableFile = TableFile, phy = tree, alpha = alpha, VAW = VAW)

  if Dtype = "d_UW"
    D = Distance[Dtype]
  elseif Dtype = "d_alpha"
    D = Distance[[string("d_", alpha)]]
  elseif Dtype = "d_VAW"
    D = Distance[Dtype]
  end

  if Kernel
    @rput D
    if frobenius
      R"K <- ToPSD(distance = D, frobenius = TRUE)"
    else
      R"K <- ToPSD(distance = D)";
    end
    R"write.table(K, paste0("Kernel_", out ".csv"), row.names=F, col.names = F, sep=',')"
    return K
  else
    writecsv(string("D_",out,".csv"), D)
    return D
  end
end
