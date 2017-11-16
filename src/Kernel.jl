
function KernelMatrix(args...;UniFrac=theUniFrac)
	N = size(UniFrac)[1]
	D2 = UniFrac .^2

    I0 = Array(Float64,N,N)
    fill!(I0, 1.0)
    I = Diagonal(I0)

    one = Array(Float64,N,1)
    fill!(one, 1.0)
    one_t = transpose(one)

    K = -0.5 * (I - one .* one_t / N) * D2 * (I - one .* one_t / N)
    #U = svdfact(K)[:U]
    #S = svdfact(K)[:S]
    #Vt = svdfact(K)[:Vt]
    # psdK = U .* abs(S) * Vt
    evecK = eigvecs(K,permute=false,scale=true)
    #writedlm("dd",evecK)
    #pwd()
    #convert(Array{Float64, 2}, evecK)
    evalK = abs(eigvals(K))
		evalK[evalK.<1e-4]=1e-4
    #orderK= sort!(evalK)[1:2]
    #evalK[evalK .==orderK[1]] = min(1e-4,orderK[2]/2)
    diagK = Diagonal(evalK)
    psdK = evecK * diagK * transpose(evecK)

    #mineig=minimum(abs(eigvals(K)))
    #psdK=psdK-mineig*I
    #psdK=convert(Array(Float64,2), psdK)
    #cholfact(psdK,[pivot=Val{true}])
    return psdK
    # return K
end
