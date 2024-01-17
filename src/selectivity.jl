"""
    get_selectivity(X::Array{T,2}, trialid, periods) where T <: Real

Compute selectivity to the categories in `trialid` in the different `periods`.

For each period, compute the mean across that period for each trial, and use those means
as inputs to a Kruskal-Wallis hypothesis test. 
"""
function get_selectivity(X::Array{T,2}, trialid, periods) where T <: Real
    cats = unique(trialid)
    ncats = length(cats)
    μ = fill(zero(T), ncats, length(periods))
    selectivity_strength = fill(0.0, size(μ,2))
    for (kk,p) in enumerate(periods)
        Xp = dropdims(mean(X[p,:],dims=1),dims=1)
        _Xq = Vector{Float64}[]
        for (ii,l) in enumerate(cats)
            tidx = findall(tt->tt==l, trialid)
            Xpt = Xp[tidx]
            μ[ii, kk] = mean(Xpt)
            push!(_Xq, Xpt)
        end
        hh = HypothesisTests.KruskalWallisTest(_Xq...)
        selectivity_strength[kk] = hh.H
    end
    μ, selectivity_strength
end

function get_selectivity(X::Array{T,3}, trialid, periods) where T <: Real
    ncells,npts,ntrials = size(X)
    cats = unique(trialid)
    ncats = length(cats)
    μ = fill(zero(T), ncats, length(periods),ncells)
    selectivity_strength = fill(0.0, size(μ,2), ncells)
    for i in 1:ncells
        μ[:,:,i], selectivity_strength[:,i] = get_selectivity(X[i,:,:], trialid, periods)
    end
    μ, selectivity_strength
end