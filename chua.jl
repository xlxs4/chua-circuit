## Imports.
using OrdinaryDiffEq
using ModelingToolkit
using ModelingToolkitStandardLibrary.Electrical
using ModelingToolkitStandardLibrary.Electrical: OnePort
using DataFrames
using Statistics
using StatsPlots
##


## Define model components.
@parameters t
function NonLinearResistor(;name, Ga, Gb, Ve)
    @named oneport = OnePort()
    @unpack v, i = oneport
    pars = @parameters Ga=Ga Gb=Gb Ve=Ve
    eqs = [
        i ~ ifelse(v < -Ve,
        Gb*(v+Ve) - Ga*Ve,
        ifelse(v > Ve,
        Gb*(v - Ve) + Ga*Ve,
        Ga*v,),)
    ]
    extend(ODESystem(eqs, t, [], pars; name=name), oneport)
end