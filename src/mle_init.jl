function create_prior(observations, K::Int, dt::Float64)
    a = rand(Float64, K)
    a /= sum(a)
    A = rand(Float64, K, K)
    @inbounds for i = 1:K
        A[i, :] /= sum(A[i, :])
    end
    R = kmeans(abs2.((filter(!isnothing, observations))'), 3, tol = 1e-6; maxiter = 10000)
    D = R.centers # get the cluster centers
    D ./= 4dt
    # D .-= (abs2(er) / dt)
    D = reverse(sort(Array{Float64,1}(D[:])))
    a, A, D
end