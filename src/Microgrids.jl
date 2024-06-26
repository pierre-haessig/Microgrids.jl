module Microgrids

import Base.@kwdef # backport Julia 1.9 syntax to 1.6-1.8 versions

export simulate,
       SalvageType, LinearSalvage, ConsistentSalvage,
       Project, Microgrid,
       DispatchableGenerator, Battery,
       NonDispatchableSource, Photovoltaic, PVInverter, WindPower,
       capacity_from_wind,
       OperationTraj, OperationStats,
       operation, aggregation, dispatch, production,
       CostFactors, MicrogridCosts, component_costs, economics

include("components.jl")
include("dispatch.jl")
include("production.jl")
include("operation.jl")
include("economics.jl")

"""
    simulate(mg::Microgrid, ε::Real=0.0)

Simulate the technical and economic performance of a Microgrid `mg`.

Discontinuous computations can optionally be relaxed (smoothed)
using the relaxation parameter `ε`:
- 0.0 means no relaxation (default value)
- 1.0 yields the strongest relaxation

Using relaxation (`ε` > 0) is recommended when using gradient-based optimization
and then a “small enough” value between 0.05 and 0.30 is suggested.

Returns:
- Operational trajectories from `sim_operation` (should be optional in future version)
- Operational statistics from `sim_operation`
- Microgrid project costs from `sim_economics`
"""
function simulate(mg::Microgrid, ε::Real=0.0)
    # Run the microgrid operation
    oper_traj = operation(mg)

    # Aggregate the operation variables
    oper_stats = aggregation(mg, oper_traj, ε)

    # Eval the microgrid costs
    mg_costs = economics(mg, oper_stats)

    return (traj=oper_traj, stats=oper_stats, costs=mg_costs)
end

end