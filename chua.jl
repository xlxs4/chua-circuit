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
function NonLinearResistor(; name, Ga, Gb, Ve)
    @named oneport = OnePort()
    @unpack v, i = oneport
    pars = @parameters Ga = Ga Gb = Gb Ve = Ve
    eqs = [
        i ~ ifelse(v < -Ve,
                Gb * (v + Ve) - Ga * Ve,
                ifelse(v > Ve,
                    Gb * (v - Ve) + Ga * Ve,
                    Ga * v,
                ),
            )
    ]
    extend(ODESystem(eqs, t, [], pars; name=name), oneport)
end
##

## Create model components.
@named L = Inductor(L=18)
@named R = Resistor(R=12.5e-3)
@named G = Conductor(G=0.565)
@named C1 = Capacitor(C=10, v_start=4)
@named C2 = Capacitor(C=100)
@named Nr = NonLinearResistor(
    Ga = -0.757576,
    Gb = -0.409091,
    Ve = 1
)
@named Gnd = Ground()
##

## Define the connections between the components.
connections = [
    connect(L.p, G.p)
    connect(G.n, Nr.p)
    connect(Nr.n, Gnd.g)
    connect(C1.p, G.n)
    connect(L.n, R.p)
    connect(G.p, C2.p)
    connect(C1.n, Gnd.g)
    connect(C2.n, Gnd.g)
    connect(R.n, Gnd.g)
]
##
