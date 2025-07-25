# Tests for Microgrids.jl

using Microgrids
using Test

include("components_tests.jl")
include("microgrid_project_tests.jl")
include("operation_tests.jl")
include("economics_tests.jl")
include("optimization_tests.jl")