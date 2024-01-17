# LabeledTimeseriesTools

Tools to work work labeled timeseries, that is timeseries where each trial is associated with a particular label. These tools were developed primarily in the context of analysing electrophysiological data, where timeseries typically represent the responses over neurons over time to different external stimuli.

## Installation

First, add the NeuralCodingRepository as a package repository in julia. Then, this package can be added in the normal fashion.

```julia
pkg> registry add https://github.com/grero/NeuralCodingRegistry.jl.git 
pkg> add LabeledTimeseriesTools
```

## Usage

### Selectivity in different time perios

To compute the selectivity, i.e. whether a timeseries represents differently to different trial types in different periods of time, use the `get_selectivity` function:

```julia
using LabeledTimeseriesTools

# dummy data
nt = 5
ncells,npts,ntrials = (3,4,2*nt)
trialid = [fill(1,nt);fill(2,nt)]
X = fill(0.0, ncells, npts, 2*nt)
X[:,:,1:nt] .= 1.0 .+ randn(ncells,npts,nt)
X[:,:,nt+1:end] .= 2.0 .+ randn(ncells,npts,nt)
μ, selectivity_strength = get_selectivity(X, trialid, [1:2,3:4])
```

`μ` is the mean activity for each cell for the different trial categories, for each period, and `selectivty_strength` is the strength of the selectivity for each cell and time period, quantified by the Kruskal-Wallis test statistics.