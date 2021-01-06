defmodule Day10 do
  @moduledoc """
  --- Day 10: Monitoring Station ---
  """

  @doc """
  --- Part One ---

  You fly into the asteroid belt and reach the Ceres monitoring station. The
  Elves here have an emergency: they're having trouble tracking all of the
  asteroids and can't be sure they're safe.

  The Elves would like to build a new monitoring station in a nearby area of
  space; they hand you a map of all of the asteroids in that region (your
  puzzle input).

  The map indicates whether each position is empty (.) or contains an
  asteroid (#). The asteroids are much smaller than they appear on the map,
  and every asteroid is exactly in the center of its marked position. The
  asteroids can be described with X,Y coordinates where X is the distance
  from the left edge and Y is the distance from the top edge (so the top-left
  corner is 0,0 and the position immediately to its right is 1,0).

  Your job is to figure out which asteroid would be the best place to build a
  new monitoring station. A monitoring station can detect any asteroid to
  which it has direct line of sight - that is, there cannot be another
  asteroid exactly between them. This line of sight can be at any angle, not
  just lines aligned to the grid or diagonally. The best location is the
  asteroid that can detect the largest number of other asteroids.

  For example, consider the following map:

  .#..#
  .....
  #####
  ....#
  ...##

  The best location for a new monitoring station on this map is the
  highlighted asteroid at 3,4 because it can detect 8 asteroids, more than
  any other location. (The only asteroid it cannot detect is the one at 1,0;
  its view of this asteroid is blocked by the asteroid at 2,2.) All other
  asteroids are worse locations; they can detect 7 or fewer other asteroids.
  Here is the number of other asteroids a monitoring station on each asteroid
  could detect:

  .7..7
  .....
  67775
  ....7
  ...87

  Here is an asteroid (#) and some examples of the ways its line of sight
  might be blocked. If there were another asteroid at the location of a
  capital letter, the locations marked with the corresponding lowercase
  letter would be blocked and could not be detected:

  #.........
  ...A......
  ...B..a...
  .EDCG....a
  ..F.c.b...
  .....c....
  ..efd.c.gb
  .......c..
  ....f...c.
  ...e..d..c

  Here are some larger examples:

  - Best is 5,8 with 33 other asteroids detected:

    ......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####

  - Best is 1,2 with 35 other asteroids detected:

    #.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###.

  - Best is 6,3 with 41 other asteroids detected:

    .#..#..###
    ####.###.#
    ....###.#.
    ..###.##.#
    ##.##.#.#.
    ....###..#
    ..#.#..#.#
    #..#.#.###
    .##...##.#
    .....#.#..

  - Best is 11,13 with 210 other asteroids detected:

    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##

  Find the best location for a new monitoring station. How many other
  asteroids can be detected from that location?

  Your puzzle answer was 329.
  """

  def most_astroids_detected do
    get_astroid_coords()
    |> detect_astroids()
    |> find_best_astroid()
    |> elem(0)
  end

  @doc """
  --- Part Two ---

  Once you give them the coordinates, the Elves quickly deploy an Instant
  Monitoring Station to the location and discover the worst: there are simply
  too many asteroids.

  The only solution is complete vaporization by giant laser.

  Fortunately, in addition to an asteroid scanner, the new monitoring station
  also comes equipped with a giant rotating laser perfect for vaporizing
  asteroids. The laser starts by pointing up and always rotates clockwise,
  vaporizing any asteroid it hits.

  If multiple asteroids are exactly in line with the station, the laser only
  has enough power to vaporize one of them before continuing its rotation. In
  other words, the same asteroids that can be detected can be vaporized, but
  if vaporizing one asteroid makes another one detectable, the newly-detected
  asteroid won't be vaporized until the laser has returned to the same
  position by rotating a full 360 degrees.

  For example, consider the following map, where the asteroid with the new
  monitoring station (and laser) is marked X:

  .#....#####...#..
  ##...##.#####..##
  ##...#...#.#####.
  ..#.....X...###..
  ..#.#.....#....##

  The first nine asteroids to get vaporized, in order, would be:

  .#....###24...#..
  ##...##.13#67..9#
  ##...#...5.8####.
  ..#.....X...###..
  ..#.#.....#....##

  Note that some asteroids (the ones behind the asteroids marked 1, 5, and 7)
  won't have a chance to be vaporized until the next full rotation. The laser
  continues rotating; the next nine to be vaporized are:

  .#....###.....#..
  ##...##...#.....#
  ##...#......1234.
  ..#.....X...5##..
  ..#.9.....8....76

  The next nine to be vaporized are then:

  .8....###.....#..
  56...9#...#.....#
  34...7...........
  ..2.....X....##..
  ..1..............

  Finally, the laser completes its first full rotation (1 through 3), a
  second rotation (4 through 8), and vaporizes the last asteroid (9) partway
  through its third rotation:

  ......234.....6..
  ......1...5.....7
  .................
  ........X....89..
  .................

  In the large example above (the one with the best monitoring station
  location at 11,13):

    - The 1st asteroid to be vaporized is at 11,12.
    - The 2nd asteroid to be vaporized is at 12,1.
    - The 3rd asteroid to be vaporized is at 12,2.
    - The 10th asteroid to be vaporized is at 12,8.
    - The 20th asteroid to be vaporized is at 16,0.
    - The 50th asteroid to be vaporized is at 16,9.
    - The 100th asteroid to be vaporized is at 10,16.
    - The 199th asteroid to be vaporized is at 9,6.
    - The 200th asteroid to be vaporized is at 8,2.
    - The 201st asteroid to be vaporized is at 10,9.
    - The 299th and final asteroid to be vaporized is at 11,1.

  The Elves are placing bets on which will be the 200th asteroid to be
  vaporized. Win the bet by determining which asteroid that will be; what do
  you get if you multiply its X coordinate by 100 and then add its Y
  coordinate? (For example, 8,2 becomes 802.)

  Your puzzle answer was 512.
  """

  def vaporize_200_astroids do
    # "inputs/day10_test2_1_input.txt")
    astroid_coords = get_astroid_coords()
    detected_astroids = detect_astroids(astroid_coords)
    {qty, best_astroid} = find_best_astroid(detected_astroids)

    if qty < 200 do
      IO.puts(
        "Error: The best observation astroid has less than 200 visible astroids surrounding it"
      )

      IO.puts(
        "Need to implement a recursive solution that allows the laser to rotate more than 1 revolution"
      )
    end

    slopes_to_astroid = detected_astroids[best_astroid]

    slope_200th =
      Map.keys(slopes_to_astroid)
      |> Enum.sort(fn slope1, slope2 ->
        {q1, slope1_r} = quadrant_slope(slope1)
        {q2, slope2_r} = quadrant_slope(slope2)
        q1 > q2 or (q1 == q2 and slope1_r >= slope2_r)
      end)
      |> Enum.at(199)

    {x, y} = slopes_to_astroid[slope_200th]
    x * 100 + y
  end

  defp quadrant_slope({rise, run}) do
    cond do
      # Replace infinite slope with a number greater than
      # any possible slope in this astroid map
      rise == 1 and run == 0 -> {3, 999.0}
      rise > 0 and run > 0 -> {3, rise / run}
      rise == 0 and run == 1 -> {2, 0}
      rise < 0 and run > 0 -> {2, rise / run}
      rise == -1 and run == 0 -> {1, -999.0}
      rise < 0 and run < 0 -> {1, rise / run}
      rise == 0 and run == -1 -> {0, 0}
      rise > 0 and run < 0 -> {0, rise / run}
    end
  end

  # common functions

  defp get_astroid_coords(input \\ "inputs/day10_input.txt") do
    File.read!(input)
    |> String.to_charlist()
    |> Enum.reduce({[], 0, 0}, fn pixel, {astroids, x, y} ->
      case pixel do
        ?\n -> {astroids, 0, y + 1}
        ?. -> {astroids, x + 1, y}
        ?# -> {[{x, y} | astroids], x + 1, y}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp find_best_astroid(detected_astroids) do
    Map.keys(detected_astroids)
    |> Enum.reduce({0, {0, 0}}, fn astroid, {max_detected, best_astroid} ->
      slopes = detected_astroids[astroid]
      # Each slope and astroid pair represents a detected astroid
      # The astroid with the most slope/astroid pairs is the best location
      detected = length(Map.keys(slopes))

      if detected > max_detected do
        {detected, astroid}
      else
        {max_detected, best_astroid}
      end
    end)
  end

  defp detect_astroids(astroid_coords) do
    detect_astroids(astroid_coords, astroid_coords, %{})
  end

  defp detect_astroids([], _astroid_coords, detected_astroids) do
    detected_astroids
  end

  defp detect_astroids([astroid | rem_astroids], astroid_coords, detected_astroids) do
    # For each astroid, find the slope of the line and the distance to each of the other astroids
    # For each slope, find the astroid that is the closest. That one is detectable.
    # Any other astroids on the same slope line are obstructed by the closest one.
    slopes =
      Enum.reduce(astroid_coords, %{}, fn dest_astroid, slopes ->
        if astroid != dest_astroid do
          slope = slope(astroid, dest_astroid)

          case slopes[slope] do
            nil ->
              Map.put(slopes, slope, dest_astroid)

            closest ->
              if dist(astroid, dest_astroid) < dist(astroid, closest) do
                Map.put(slopes, slope, dest_astroid)
              else
                slopes
              end
          end
        else
          slopes
        end
      end)

    detected_astroids = Map.put(detected_astroids, astroid, slopes)
    detect_astroids(rem_astroids, astroid_coords, detected_astroids)
  end

  defp dist({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1
    :math.sqrt(dx * dx + dy * dy)
  end

  defp slope({x1, y1}, {x2, y2}) do
    run = x2 - x1
    rise = y1 - y2
    gcd = gcd(rise, run)
    {div(rise, gcd), div(run, gcd)}
  end

  defp gcd(a, 0), do: abs(a)
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
