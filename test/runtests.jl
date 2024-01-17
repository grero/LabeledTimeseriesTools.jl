using Test
using LabeledTimeseriesTools
using StableRNGs

@testset "Selectivity" begin
    rng = StableRNG(1234)
    nt = 50 
    X = fill(0.0, 4, 3*nt)
    trialid = [fill(1,nt);fill(2,nt);fill(3,nt)]
    periods = [1:2,3:4]
    X[:,1:nt] .= 1.0 .+ 0.1*randn(rng, (4,nt))
    X[:,nt+1:2*nt] .= 2.0 .+ 0.05*randn(rng, (4,nt))
    X[:,2*nt+1:end] .= 3.0 .+ 0.05*randn(rng, (4,nt))

    μ, selectivity_strength = get_selectivity(X,trialid,periods)
    @test isapprox(μ[:,1],[1.0, 2.0, 3.0], atol=0.1)
    @test isapprox(μ[:,2],[1.0, 2.0, 3.0], atol=0.1)
    @test isapprox(selectivity_strength, [132.4503311258278, 132.4503311258278])

    # multiple cells
    XX = permutedims(cat(X,X,dims=3),(3,1,2))
    μ2, selectivity_strength2 = get_selectivity(XX,trialid,periods)
    @test size(μ2) == (3,2,2)
    @test size(selectivity_strength2) == (2,2)
    @test μ2[:,:,1] ≈ μ
    @test μ2[:,:,2] ≈ μ
    @test selectivity_strength2[:,1] ≈ selectivity_strength
    @test selectivity_strength2[:,2] ≈ selectivity_strength
end