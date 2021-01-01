defmodule Day03 do
  @moduledoc """
  --- Day 3: Crossed Wires ---
  """

  @doc """
  --- Part One ---

  The gravity assist was successful, and you're well on your way to the Venus refuelling station.
  During the rush back on Earth, the fuel management system wasn't completely installed,
  so that's next on the priority list.

  Opening the front panel reveals a jumble of wires. Specifically, two wires are connected
  to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port,
  one wire per line of text (your puzzle input).

  The wires twist and turn, but the two wires occasionally cross paths.
  To fix the circuit, you need to find the intersection point closest to the central port.
  Because the wires are on a grid, use the Manhattan distance for this measurement.
  While the wires do technically cross right at the central port where they both start,
  this point does not count, nor does a wire count as crossing with itself.

  For example, if the first wire's path is R8,U5,L5,D3, then starting from the central port (o),
  it goes right 8, up 5, left 5, and finally down 3:

  ...........
  ...........
  ...........
  ....+----+.
  ....|....|.
  ....|....|.
  ....|....|.
  .........|.
  .o-------+.
  ...........

  Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4, and left 4:

  ...........
  .+-----+...
  .|.....|...
  .|..+--X-+.
  .|..|..|.|.
  .|.-X--+.|.
  .|..|....|.
  .|.......|.
  .o-------+.
  ...........

  These wires cross at two locations (marked X), but the lower-left one is closer to the central port:
  its distance is 3 + 3 = 6.

  Here are a few more examples:

  R75,D30,R83,U83,L12,D49,R71,U7,L72
  U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
  R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
  U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135
  What is the Manhattan distance from the central port to the closest intersection?
  """

  def find_closest_intersect do
    # "inputs/day03_test1_2_input.txt")
    [wire1, wire2] = get_wires()
    wire1_path = plot_wire_path(wire1, MapSet.new([{0, 0}]), {0, 0})
    wire2_path = plot_wire_path(wire2, MapSet.new([{0, 0}]), {0, 0})
    dist_to_closest_intersect(wire1_path, wire2_path)
  end

  defp plot_wire_path([], coords, _last_coord), do: coords

  defp plot_wire_path([{dir, length} | rem_runs], coords, last_coord) do
    {coords, last_coord} =
      case dir do
        "L" -> gen_wire_path_x(coords, last_coord, -length)
        "R" -> gen_wire_path_x(coords, last_coord, length)
        "U" -> gen_wire_path_y(coords, last_coord, length)
        "D" -> gen_wire_path_y(coords, last_coord, -length)
      end

    plot_wire_path(rem_runs, coords, last_coord)
  end

  defp gen_wire_path_x(coords, {last_x, last_y}, length) do
    start_x =
      cond do
        length < 0 -> last_x - 1
        length > 0 -> last_x + 1
      end

    last_x = last_x + length

    coords =
      Enum.reduce(start_x..last_x, coords, fn x, next_coords ->
        MapSet.put(next_coords, {x, last_y})
      end)

    {coords, {last_x, last_y}}
  end

  defp gen_wire_path_y(coords, {last_x, last_y}, length) do
    start_y =
      cond do
        length < 0 -> last_y - 1
        length > 0 -> last_y + 1
      end

    last_y = last_y + length

    coords =
      Enum.reduce(start_y..last_y, coords, fn y, next_coords ->
        MapSet.put(next_coords, {last_x, y})
      end)

    {coords, {last_x, last_y}}
  end

  defp dist_to_closest_intersect(wire1_path, wire2_path) do
    MapSet.intersection(wire1_path, wire2_path)
    |> MapSet.to_list()
    |> Enum.reject(&(&1 == {0, 0}))
    |> Enum.reduce(999_999_999, fn {x, y}, min_dist ->
      min(min_dist, abs(x) + abs(y))
    end)
  end

  @doc """
  --- Part Two ---

  It turns out that this circuit is very timing-sensitive; you actually need to minimize the signal delay.

  To do this, calculate the number of steps each wire takes to reach each intersection;
  choose the intersection where the sum of both wires' steps is lowest.
  If a wire visits a position on the grid multiple times, use the steps value
  from the first time it visits that position when calculating the total value of a specific intersection.

  The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location,
  including the intersection being considered. Again consider the example from above:

  ...........
  .+-----+...
  .|.....|...
  .|..+--X-+.
  .|..|..|.|.
  .|.-X--+.|.
  .|..|....|.
  .|.......|.
  .o-------+.
  ...........

  In the above example, the intersection closest to the central port is reached after 8+5+5+2 = 20 steps
  by the first wire and 7+6+4+3 = 20 steps by the second wire for a total of 20+20 = 40 steps.

  However, the top-right intersection is better: the first wire takes only 8+5+2 = 15
  and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

  Here are the best steps for the extra examples from above:

  R75,D30,R83,U83,L12,D49,R71,U7,L72
  U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
  R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
  U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps
  What is the fewest combined steps the wires must take to reach an intersection?
  """

  def find_min_delay do
    # "inputs/day03_test1_2_input.txt")
    [wire1, wire2] = get_wires()
    wire1_path = plot_wire_path2(wire1, Map.put(%{}, {0, 0}, 0), {0, 0})
    wire2_path = plot_wire_path2(wire2, Map.put(%{}, {0, 0}, 0), {0, 0})
    shortest_path_to_intersect(wire1_path, wire2_path)
  end

  defp plot_wire_path2([], coords, _last_coord), do: coords

  defp plot_wire_path2([{dir, length} | rem_runs], coords, last_coord) do
    {coords, last_coord} =
      case dir do
        "L" -> gen_wire_path2_x(coords, last_coord, -length)
        "R" -> gen_wire_path2_x(coords, last_coord, length)
        "U" -> gen_wire_path2_y(coords, last_coord, length)
        "D" -> gen_wire_path2_y(coords, last_coord, -length)
      end

    plot_wire_path2(rem_runs, coords, last_coord)
  end

  defp gen_wire_path2_x(coords, {last_x, last_y}, length) do
    last_steps = coords[{last_x, last_y}]

    start_x =
      cond do
        length < 0 -> last_x - 1
        length > 0 -> last_x + 1
      end

    last_x = last_x + length

    {coords, _steps} =
      Enum.reduce(start_x..last_x, {coords, last_steps}, fn x, {next_coords, next_steps} ->
        next_steps = next_steps + 1

        if coords[{x, last_y}] == nil do
          {Map.put(next_coords, {x, last_y}, next_steps), next_steps}
        else
          {next_coords, next_steps}
        end
      end)

    {coords, {last_x, last_y}}
  end

  defp gen_wire_path2_y(coords, {last_x, last_y}, length) do
    last_steps = coords[{last_x, last_y}]

    start_y =
      cond do
        length < 0 -> last_y - 1
        length > 0 -> last_y + 1
      end

    last_y = last_y + length

    {coords, _steps} =
      Enum.reduce(start_y..last_y, {coords, last_steps}, fn y, {next_coords, next_steps} ->
        next_steps = next_steps + 1

        if coords[{last_x, y}] == nil do
          {Map.put(next_coords, {last_x, y}, next_steps), next_steps}
        else
          {next_coords, next_steps}
        end
      end)

    {coords, {last_x, last_y}}
  end

  defp shortest_path_to_intersect(wire1_path, wire2_path) do
    wire1_coords =
      Map.keys(wire1_path)
      |> MapSet.new()

    wire2_coords =
      Map.keys(wire2_path)
      |> MapSet.new()

    MapSet.intersection(wire1_coords, wire2_coords)
    |> MapSet.to_list()
    |> Enum.reject(&(&1 == {0, 0}))
    |> Enum.reduce(999_999_999, fn intersect, min_steps ->
      min(min_steps, wire1_path[intersect] + wire2_path[intersect])
    end)
  end

  # common functions

  defp get_wires(input \\ "inputs/day03_input.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_dirs/1)
  end

  defp parse_dirs(wire_dirs) do
    String.split(wire_dirs, ",")
    |> Enum.map(fn dir_len ->
      dir = String.at(dir_len, 0)
      len = String.to_integer(String.slice(dir_len, 1, 4))
      {dir, len}
    end)
  end
end
