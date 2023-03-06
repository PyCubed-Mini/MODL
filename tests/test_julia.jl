using Test
using PyCall
using GNCTestServer

MODL = pyimport("src")

@testset "sun test" begin
    approx_sun_position_ECI = MODL.sun_position.approx_sun_position_ECI
    tests = [1677520808.726837, 1677520208.726837]
    foreach(test ->
        @test approx_sun_position_ECI(test) ≈ GNCTestServer.sun_position(test))
end

@testset "Time derivative test" begin
    d_state = MODL.d_state
    tests = []
    foreach(test ->
        @test d_state(test) ≈ GNCTestServer.dynamics(test))
end

@testset "rk4 test" begin
    rk4 = MODL.orbital_mechanics.rk4
    tests = []
    foreach(test ->
        @test rk4(test) ≈ GNCTestServer.rk4(test))
end

@testset "propgate test" begin
    propogate = MODL.orbital_mechanics.propgate
    tests = []
    foreach(test -> @test propogate(test) ≈ GNCTestServer.integrate_state(test))
end