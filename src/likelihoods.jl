function _likelihood!(dR, D, L, dt, error)
    d = Diffusion.(D, dt, error)
    @inbounds for i in 1:track_num
        @inbounds for t in 1:track_length[i] + 1
            @inbounds for s in 1:K
                L[t, s, i] = pdf.(d[s], ifelse(dR[t, s, i] < 1e-4, 1e-4, dR[t, s, i]))
            end
        end
    end
end

function likelihood!(
        observations::AbstractArray,
        L::AbstractArray,
        D,
        dt,
        error,
        track_length
    )
    @argcheck size(observations) == size(L)
    K, N = size(L, 2), size(L, 3)
    d = Diffusion.(D, dt, error)
    @inbounds for i in 1:N
        @inbounds for t in 1:track_length[i] + 1
            @inbounds for j in 1:K
                L[t, j, i] = pdf.(d[j],
                    ifelse(observations[t, j, i] < 1e-4, 1e-4, observations[t, j, i]))
            end
        end
    end
end

function loglikelihood!(
        observations::AbstractArray,
        L::AbstractArray,
        D,
        dt,
        error
    )
    @argcheck size(observations) == size(L)
    K, N = size(L, 2), size(L, 3)
    fill!(L, 0.0)

    @inbounds for i in 1:N
        @inbounds for t in 1:track_length[i]
            @inbounds for j in 1:K
                L[t, j, i] = logpdf.(d[j],
                    ifelse(observations[t, j, i] < 1e-4, 1e-4, observations[t, j, i]))
            end
        end
    end
end