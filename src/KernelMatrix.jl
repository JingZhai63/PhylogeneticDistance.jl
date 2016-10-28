
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
    evecK = eigvecs(K)
    diagK = Diagonal(abs(eigvals(K)))
    psdK = evecK * diagK * transpose(evecK)

    return psdK
end


