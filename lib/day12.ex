defmodule Day12 do
  @moduledoc """
  --- Day 12: The N-Body Problem ---
  """

  @doc """
  --- Part One ---

  The space near Jupiter is not a very safe place; you need to be careful of
  a big distracting red spot, extreme radiation, and a whole lot of moons
  swirling around. You decide to start by tracking the four largest moons:
  Io, Europa, Ganymede, and Callisto.

  After a brief scan, you calculate the position of each moon (your puzzle
  input). You just need to simulate their motion so you can avoid them.

  Each moon has a 3-dimensional position (x, y, and z) and a 3-dimensional
  velocity. The position of each moon is given in your scan; the x, y, and z
  velocity of each moon starts at 0.

  Simulate the motion of the moons in time steps. Within each time step,
  first update the velocity of every moon by applying gravity. Then, once all
  moons' velocities have been updated, update the position of every moon by
  applying velocity. Time progresses by one step once all of the positions
  are updated.

  To apply gravity, consider every pair of moons. On each axis (x, y, and z),
  the velocity of each moon changes by exactly +1 or -1 to pull the moons
  together. For example, if Ganymede has an x position of 3, and Callisto has
  a x position of 5, then Ganymede's x velocity changes by +1 (because 5 > 3)
  and Callisto's x velocity changes by -1 (because 3 < 5). However, if the
  positions on a given axis are the same, the velocity on that axis does not
  change for that pair of moons.

  Once all gravity has been applied, apply velocity: simply add the velocity
  of each moon to its own position. For example, if Europa has a position of
  x=1, y=2, z=3 and a velocity of x=-2, y=0,z=3, then its new position would
  be x=-1, y=2, z=6. This process does not modify the velocity of any moon.

  For example, suppose your scan reveals the following positions:

  <x=-1, y=0, z=2>
  <x=2, y=-10, z=-7>
  <x=4, y=-8, z=8>
  <x=3, y=5, z=-1>

  Simulating the motion of these moons would produce the following:

  After 0 steps:
  pos=<x=-1, y=  0, z= 2>, vel=<x= 0, y= 0, z= 0>
  pos=<x= 2, y=-10, z=-7>, vel=<x= 0, y= 0, z= 0>
  pos=<x= 4, y= -8, z= 8>, vel=<x= 0, y= 0, z= 0>
  pos=<x= 3, y=  5, z=-1>, vel=<x= 0, y= 0, z= 0>

  After 1 step:
  pos=<x= 2, y=-1, z= 1>, vel=<x= 3, y=-1, z=-1>
  pos=<x= 3, y=-7, z=-4>, vel=<x= 1, y= 3, z= 3>
  pos=<x= 1, y=-7, z= 5>, vel=<x=-3, y= 1, z=-3>
  pos=<x= 2, y= 2, z= 0>, vel=<x=-1, y=-3, z= 1>

  After 2 steps:
  pos=<x= 5, y=-3, z=-1>, vel=<x= 3, y=-2, z=-2>
  pos=<x= 1, y=-2, z= 2>, vel=<x=-2, y= 5, z= 6>
  pos=<x= 1, y=-4, z=-1>, vel=<x= 0, y= 3, z=-6>
  pos=<x= 1, y=-4, z= 2>, vel=<x=-1, y=-6, z= 2>

  After 3 steps:
  pos=<x= 5, y=-6, z=-1>, vel=<x= 0, y=-3, z= 0>
  pos=<x= 0, y= 0, z= 6>, vel=<x=-1, y= 2, z= 4>
  pos=<x= 2, y= 1, z=-5>, vel=<x= 1, y= 5, z=-4>
  pos=<x= 1, y=-8, z= 2>, vel=<x= 0, y=-4, z= 0>

  After 4 steps:
  pos=<x= 2, y=-8, z= 0>, vel=<x=-3, y=-2, z= 1>
  pos=<x= 2, y= 1, z= 7>, vel=<x= 2, y= 1, z= 1>
  pos=<x= 2, y= 3, z=-6>, vel=<x= 0, y= 2, z=-1>
  pos=<x= 2, y=-9, z= 1>, vel=<x= 1, y=-1, z=-1>

  After 5 steps:
  pos=<x=-1, y=-9, z= 2>, vel=<x=-3, y=-1, z= 2>
  pos=<x= 4, y= 1, z= 5>, vel=<x= 2, y= 0, z=-2>
  pos=<x= 2, y= 2, z=-4>, vel=<x= 0, y=-1, z= 2>
  pos=<x= 3, y=-7, z=-1>, vel=<x= 1, y= 2, z=-2>

  After 6 steps:
  pos=<x=-1, y=-7, z= 3>, vel=<x= 0, y= 2, z= 1>
  pos=<x= 3, y= 0, z= 0>, vel=<x=-1, y=-1, z=-5>
  pos=<x= 3, y=-2, z= 1>, vel=<x= 1, y=-4, z= 5>
  pos=<x= 3, y=-4, z=-2>, vel=<x= 0, y= 3, z=-1>

  After 7 steps:
  pos=<x= 2, y=-2, z= 1>, vel=<x= 3, y= 5, z=-2>
  pos=<x= 1, y=-4, z=-4>, vel=<x=-2, y=-4, z=-4>
  pos=<x= 3, y=-7, z= 5>, vel=<x= 0, y=-5, z= 4>
  pos=<x= 2, y= 0, z= 0>, vel=<x=-1, y= 4, z= 2>

  After 8 steps:
  pos=<x= 5, y= 2, z=-2>, vel=<x= 3, y= 4, z=-3>
  pos=<x= 2, y=-7, z=-5>, vel=<x= 1, y=-3, z=-1>
  pos=<x= 0, y=-9, z= 6>, vel=<x=-3, y=-2, z= 1>
  pos=<x= 1, y= 1, z= 3>, vel=<x=-1, y= 1, z= 3>

  After 9 steps:
  pos=<x= 5, y= 3, z=-4>, vel=<x= 0, y= 1, z=-2>
  pos=<x= 2, y=-9, z=-3>, vel=<x= 0, y=-2, z= 2>
  pos=<x= 0, y=-8, z= 4>, vel=<x= 0, y= 1, z=-2>
  pos=<x= 1, y= 1, z= 5>, vel=<x= 0, y= 0, z= 2>

  After 10 steps:
  pos=<x= 2, y= 1, z=-3>, vel=<x=-3, y=-2, z= 1>
  pos=<x= 1, y=-8, z= 0>, vel=<x=-1, y= 1, z= 3>
  pos=<x= 3, y=-6, z= 1>, vel=<x= 3, y= 2, z=-3>
  pos=<x= 2, y= 0, z= 4>, vel=<x= 1, y=-1, z=-1>

  Then, it might help to calculate the total energy in the system. The total
  energy for a single moon is its potential energy multiplied by its kinetic
  energy. A moon's potential energy is the sum of the absolute values of its
  x, y, and z position coordinates. A moon's kinetic energy is the sum of the
  absolute values of its velocity coordinates. Below, each line shows the
  calculations for a moon's potential energy (pot), kinetic energy (kin), and
  total energy:

  Energy after 10 steps:
  pot: 2 + 1 + 3 =  6;   kin: 3 + 2 + 1 = 6;   total:  6 * 6 = 36
  pot: 1 + 8 + 0 =  9;   kin: 1 + 1 + 3 = 5;   total:  9 * 5 = 45
  pot: 3 + 6 + 1 = 10;   kin: 3 + 2 + 3 = 8;   total: 10 * 8 = 80
  pot: 2 + 0 + 4 =  6;   kin: 1 + 1 + 1 = 3;   total:  6 * 3 = 18
  Sum of total energy: 36 + 45 + 80 + 18 = 179

  In the above example, adding together the total energy for all moons after
  10 steps produces the total energy in the system, 179.

  Here's a second example:

  <x=-8, y=-10, z=0>
  <x=5, y=5, z=10>
  <x=2, y=-7, z=3>
  <x=9, y=-8, z=-3>

  Every ten steps of simulation for 100 steps produces:

  After 0 steps:
  pos=<x= -8, y=-10, z=  0>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  5, y=  5, z= 10>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  2, y= -7, z=  3>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  9, y= -8, z= -3>, vel=<x=  0, y=  0, z=  0>

  After 10 steps:
  pos=<x= -9, y=-10, z=  1>, vel=<x= -2, y= -2, z= -1>
  pos=<x=  4, y= 10, z=  9>, vel=<x= -3, y=  7, z= -2>
  pos=<x=  8, y=-10, z= -3>, vel=<x=  5, y= -1, z= -2>
  pos=<x=  5, y=-10, z=  3>, vel=<x=  0, y= -4, z=  5>

  After 20 steps:
  pos=<x=-10, y=  3, z= -4>, vel=<x= -5, y=  2, z=  0>
  pos=<x=  5, y=-25, z=  6>, vel=<x=  1, y=  1, z= -4>
  pos=<x= 13, y=  1, z=  1>, vel=<x=  5, y= -2, z=  2>
  pos=<x=  0, y=  1, z=  7>, vel=<x= -1, y= -1, z=  2>

  After 30 steps:
  pos=<x= 15, y= -6, z= -9>, vel=<x= -5, y=  4, z=  0>
  pos=<x= -4, y=-11, z=  3>, vel=<x= -3, y=-10, z=  0>
  pos=<x=  0, y= -1, z= 11>, vel=<x=  7, y=  4, z=  3>
  pos=<x= -3, y= -2, z=  5>, vel=<x=  1, y=  2, z= -3>

  After 40 steps:
  pos=<x= 14, y=-12, z= -4>, vel=<x= 11, y=  3, z=  0>
  pos=<x= -1, y= 18, z=  8>, vel=<x= -5, y=  2, z=  3>
  pos=<x= -5, y=-14, z=  8>, vel=<x=  1, y= -2, z=  0>
  pos=<x=  0, y=-12, z= -2>, vel=<x= -7, y= -3, z= -3>

  After 50 steps:
  pos=<x=-23, y=  4, z=  1>, vel=<x= -7, y= -1, z=  2>
  pos=<x= 20, y=-31, z= 13>, vel=<x=  5, y=  3, z=  4>
  pos=<x= -4, y=  6, z=  1>, vel=<x= -1, y=  1, z= -3>
  pos=<x= 15, y=  1, z= -5>, vel=<x=  3, y= -3, z= -3>

  After 60 steps:
  pos=<x= 36, y=-10, z=  6>, vel=<x=  5, y=  0, z=  3>
  pos=<x=-18, y= 10, z=  9>, vel=<x= -3, y= -7, z=  5>
  pos=<x=  8, y=-12, z= -3>, vel=<x= -2, y=  1, z= -7>
  pos=<x=-18, y= -8, z= -2>, vel=<x=  0, y=  6, z= -1>

  After 70 steps:
  pos=<x=-33, y= -6, z=  5>, vel=<x= -5, y= -4, z=  7>
  pos=<x= 13, y= -9, z=  2>, vel=<x= -2, y= 11, z=  3>
  pos=<x= 11, y= -8, z=  2>, vel=<x=  8, y= -6, z= -7>
  pos=<x= 17, y=  3, z=  1>, vel=<x= -1, y= -1, z= -3>

  After 80 steps:
  pos=<x= 30, y= -8, z=  3>, vel=<x=  3, y=  3, z=  0>
  pos=<x= -2, y= -4, z=  0>, vel=<x=  4, y=-13, z=  2>
  pos=<x=-18, y= -7, z= 15>, vel=<x= -8, y=  2, z= -2>
  pos=<x= -2, y= -1, z= -8>, vel=<x=  1, y=  8, z=  0>

  After 90 steps:
  pos=<x=-25, y= -1, z=  4>, vel=<x=  1, y= -3, z=  4>
  pos=<x=  2, y= -9, z=  0>, vel=<x= -3, y= 13, z= -1>
  pos=<x= 32, y= -8, z= 14>, vel=<x=  5, y= -4, z=  6>
  pos=<x= -1, y= -2, z= -8>, vel=<x= -3, y= -6, z= -9>

  After 100 steps:
  pos=<x=  8, y=-12, z= -9>, vel=<x= -7, y=  3, z=  0>
  pos=<x= 13, y= 16, z= -3>, vel=<x=  3, y=-11, z= -5>
  pos=<x=-29, y=-11, z= -1>, vel=<x= -3, y=  7, z=  4>
  pos=<x= 16, y=-13, z= 23>, vel=<x=  7, y=  1, z=  1>

  Energy after 100 steps:
  pot:  8 + 12 +  9 = 29;   kin: 7 +  3 + 0 = 10;   total: 29 * 10 = 290
  pot: 13 + 16 +  3 = 32;   kin: 3 + 11 + 5 = 19;   total: 32 * 19 = 608
  pot: 29 + 11 +  1 = 41;   kin: 3 +  7 + 4 = 14;   total: 41 * 14 = 574
  pot: 16 + 13 + 23 = 52;   kin: 7 +  1 + 1 =  9;   total: 52 *  9 = 468
  Sum of total energy: 290 + 608 + 574 + 468 = 1940

  What is the total energy in the system after simulating the moons given in
  your scan for 1000 steps?

  Your puzzle answer was 9441.
  """

  def total_energy do
    get_moons()
    |> step_time(1000)
    |> calc_total_energy()
  end

  defp step_time(moons, 0), do: moons

  defp step_time(moons, step) do
    moons =
      apply_gravity(moons)
      |> Enum.map(&apply_velocity/1)

    step_time(moons, step - 1)
  end

  defp calc_total_energy(moons) do
    Enum.reduce(moons, 0, fn moon, total_energy ->
      total_energy + pot_energy(moon) * kin_energy(moon)
    end)
  end

  defp pot_energy(moon) do
    energy(moon[:pos])
  end

  defp kin_energy(moon) do
    energy(moon[:vel])
  end

  defp energy(vector) do
    abs(vector[:x]) + abs(vector[:y]) + abs(vector[:z])
  end

  @doc """
  --- Part Two ---

  All this drifting around in space makes you wonder about the nature of the
  universe. Does history really repeat itself? You're curious whether the
  moons will ever return to a previous state.

  Determine the number of steps that must occur before all of the moons'
  positions and velocities exactly match a previous point in time.

  For example, the first example above takes 2772 steps before they exactly
  match a previous point in time; it eventually returns to the initial state:

  After 0 steps:
  pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>

  After 2770 steps:
  pos=<x=  2, y= -1, z=  1>, vel=<x= -3, y=  2, z=  2>
  pos=<x=  3, y= -7, z= -4>, vel=<x=  2, y= -5, z= -6>
  pos=<x=  1, y= -7, z=  5>, vel=<x=  0, y= -3, z=  6>
  pos=<x=  2, y=  2, z=  0>, vel=<x=  1, y=  6, z= -2>

  After 2771 steps:
  pos=<x= -1, y=  0, z=  2>, vel=<x= -3, y=  1, z=  1>
  pos=<x=  2, y=-10, z= -7>, vel=<x= -1, y= -3, z= -3>
  pos=<x=  4, y= -8, z=  8>, vel=<x=  3, y= -1, z=  3>
  pos=<x=  3, y=  5, z= -1>, vel=<x=  1, y=  3, z= -1>

  After 2772 steps:
  pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
  pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>

  Of course, the universe might last for a very long time before repeating.
  Here's a copy of the second example from above:

  <x=-8, y=-10, z=0>
  <x=5, y=5, z=10>
  <x=2, y=-7, z=3>
  <x=9, y=-8, z=-3>

  This set of initial positions takes 4686774924 steps before it repeats a
  previous state! Clearly, you might need to find a more efficient way to
  simulate the universe.

  How many steps does it take to reach the first state that exactly matches a
  previous state?

  Your puzzle answer was 503560201099704.
  """

  def matching_state do
    moons = get_moons()
    steps_x = match(moons, :x)
    steps_y = match(moons, :y)
    steps_z = match(moons, :z)
    # IO.puts("#{inspect({steps_x, steps_y, steps_z})}")
    lcm(lcm(steps_x, steps_y), steps_z)
  end

  defp match([m1, m2, m3, m4], axis) do
    init_state = %{
      p1: m1[:pos][axis],
      p2: m2[:pos][axis],
      p3: m3[:pos][axis],
      p4: m4[:pos][axis],
      v1: m1[:vel][axis],
      v2: m2[:vel][axis],
      v3: m3[:vel][axis],
      v4: m4[:vel][axis]
    }

    steps_to_match(init_state, init_state, 0)
  end

  defp steps_to_match(curr_state, init_state, count) do
    {v1, v2} = apply_gravity(curr_state[:p1], curr_state[:p2], curr_state[:v1], curr_state[:v2])
    curr_state = Map.put(curr_state, :v1, v1)
    curr_state = Map.put(curr_state, :v2, v2)

    {v1, v3} = apply_gravity(curr_state[:p1], curr_state[:p3], curr_state[:v1], curr_state[:v3])
    curr_state = Map.put(curr_state, :v1, v1)
    curr_state = Map.put(curr_state, :v3, v3)

    {v1, v4} = apply_gravity(curr_state[:p1], curr_state[:p4], curr_state[:v1], curr_state[:v4])
    curr_state = Map.put(curr_state, :v1, v1)
    curr_state = Map.put(curr_state, :v4, v4)

    {v2, v3} = apply_gravity(curr_state[:p2], curr_state[:p3], curr_state[:v2], curr_state[:v3])
    curr_state = Map.put(curr_state, :v2, v2)
    curr_state = Map.put(curr_state, :v3, v3)

    {v2, v4} = apply_gravity(curr_state[:p2], curr_state[:p4], curr_state[:v2], curr_state[:v4])
    curr_state = Map.put(curr_state, :v2, v2)
    curr_state = Map.put(curr_state, :v4, v4)

    {v3, v4} = apply_gravity(curr_state[:p3], curr_state[:p4], curr_state[:v3], curr_state[:v4])
    curr_state = Map.put(curr_state, :v3, v3)
    curr_state = Map.put(curr_state, :v4, v4)

    curr_state = apply_velocity_axis(curr_state)

    if curr_state == init_state do
      count + 1
    else
      steps_to_match(curr_state, init_state, count + 1)
    end
  end

  # common functions

  defp get_moons(input \\ "inputs/day12_input.txt") do
    File.read!(input)
    |> String.split("\n")
    |> Enum.map(fn moon ->
      %{pos: parse_pos(moon), vel: %{x: 0, y: 0, z: 0}}
    end)
  end

  defp parse_pos(xyz) do
    Regex.named_captures(
      ~r/^<x=(?'x'[-,\d][\d]*), y=(?'y'[-,\d][\d]*), z=(?'z'[-,\d][\d]*)>$/,
      xyz
    )
    |> Enum.reduce(%{}, fn {axis, value}, pos ->
      Map.put(pos, String.to_atom(axis), String.to_integer(value))
    end)
  end

  defp apply_gravity([m1, m2, m3, m4]) do
    {m1, m2} = apply_gravity(m1, m2)
    {m1, m3} = apply_gravity(m1, m3)
    {m1, m4} = apply_gravity(m1, m4)
    {m2, m3} = apply_gravity(m2, m3)
    {m2, m4} = apply_gravity(m2, m4)
    {m3, m4} = apply_gravity(m3, m4)
    [m1, m2, m3, m4]
  end

  # Between two moons
  defp apply_gravity(m1, m2) do
    p1 = m1[:pos]
    v1 = m1[:vel]
    p2 = m2[:pos]
    v2 = m2[:vel]
    {v1_x, v2_x} = apply_gravity(p1[:x], p2[:x], v1[:x], v2[:x])
    {v1_y, v2_y} = apply_gravity(p1[:y], p2[:y], v1[:y], v2[:y])
    {v1_z, v2_z} = apply_gravity(p1[:z], p2[:z], v1[:z], v2[:z])

    {
      Map.put(m1, :vel, %{x: v1_x, y: v1_y, z: v1_z}),
      Map.put(m2, :vel, %{x: v2_x, y: v2_y, z: v2_z})
    }
  end

  # Along one axis
  defp apply_gravity(p1, p2, v1, v2) do
    cond do
      p1 == p2 -> {v1, v2}
      p1 > p2 -> {v1 - 1, v2 + 1}
      p1 < p2 -> {v1 + 1, v2 - 1}
    end
  end

  defp apply_velocity(moon) do
    pos = moon[:pos]
    vel = moon[:vel]
    p_x = pos[:x] + vel[:x]
    p_y = pos[:y] + vel[:y]
    p_z = pos[:z] + vel[:z]
    Map.put(moon, :pos, %{x: p_x, y: p_y, z: p_z})
  end

  defp apply_velocity_axis(state) do
    state = Map.put(state, :p1, state[:p1] + state[:v1])
    state = Map.put(state, :p2, state[:p2] + state[:v2])
    state = Map.put(state, :p3, state[:p3] + state[:v3])
    Map.put(state, :p4, state[:p4] + state[:v4])
  end

  defp lcm(a, b), do: div(abs(a * b), gcd(a, b))

  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
