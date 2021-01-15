defmodule Day13 do
  @moduledoc """
  --- Day 13: Care Package ---
  """

  @doc """
  --- Part One ---

  As you ponder the solitude of space and the ever-increasing three-hour
  roundtrip for messages between you and Earth, you notice that the Space
  Mail Indicator Light is blinking. To help keep you sane, the Elves have
  sent you a care package.

  It's a new game for the ship's arcade cabinet! Unfortunately, the arcade is
  all the way on the other end of the ship. Surely, it won't be hard to build
  your own - the care package even comes with schematics.

  The arcade cabinet runs Intcode software like the game the Elves sent (your
  puzzle input). It has a primitive screen capable of drawing square tiles on
  a grid. The software draws tiles to the screen with output instructions:
  every three output instructions specify the x position (distance from the
  left), y position (distance from the top), and tile id. The tile id is
  interpreted as follows:

    - 0 is an empty tile. No game object appears in this tile.
    - 1 is a wall tile. Walls are indestructible barriers.
    - 2 is a block tile. Blocks can be broken by the ball.
    - 3 is a horizontal paddle tile. The paddle is indestructible.
    - 4 is a ball tile. The ball moves diagonally and bounces off objects.

  For example, a sequence of output values like 1,2,3,6,5,4 would draw a
  horizontal paddle tile (1 tile from the left and 2 tiles from the top) and
  a ball tile (6 tiles from the left and 5 tiles from the top).

  Start the game. How many block tiles are on the screen when the game exits?

  Your puzzle answer was 361.
  """

  @block 2
  @paddle 3
  @ball 4

  def count_on_screen_block_tiles do
    get_code()
    |> Intcode.new()
    |> run_program_1([])
    |> Enum.filter(fn [_x, _y, tile] -> tile == @block end)
    |> Enum.count()
  end

  defp run_program_1(program, tiles) do
    {program, outputs} = run_and_get_3_outputs(program)

    if Intcode.halted?(program) do
      Enum.reverse(tiles)
    else
      run_program_1(program, [outputs | tiles])
    end
  end

  defp run_and_get_3_outputs(program) do
    program =
      Intcode.run(program)
      |> Intcode.run()
      |> Intcode.run()

    outputs = Intcode.get_outputs(program)
    program = Intcode.clear_outputs(program)
    {program, outputs}
  end

  @doc """
  --- Part Two ---

  The game didn't run because you didn't put in any quarters. Unfortunately,
  you did not bring any quarters. Memory address 0 represents the number of
  quarters that have been inserted; set it to 2 to play for free.

  The arcade cabinet has a joystick that can move left and right. The
  software reads the position of the joystick with input instructions:

    - If the joystick is in the neutral position, provide 0.
    - If the joystick is tilted to the left, provide -1.
    - If the joystick is tilted to the right, provide 1.

  The arcade cabinet also has a segment display capable of showing a single
  number that represents the player's current score. When three output
  instructions specify X=-1, Y=0, the third output instruction is not a tile;
  the value instead specifies the new score to show in the segment display.
  For example, a sequence of output values like -1,0,12345 would show 12345
  as the player's current score.

  Beat the game by breaking all the blocks. What is your score after the last
  block is broken?

  Your puzzle answer was 17590.
  """

  def play_game do
    get_code()
    |> Intcode.new()
    # Hack the game program for free play
    |> Intcode.set_addr(0, 2)
    |> free_play(0, 0, 0, 0)
  end

  defp free_play(program, ball_x, paddle_x, score, input) do
    {program, x, _halted} = run_input_to_output(program, input)
    {program, _y, _halted} = run_to_output(program)
    {program, obj, halted} = run_to_output(program)

    if !halted do
      if x == -1 do
        free_play(program, ball_x, paddle_x, obj, 0)
      else
        case obj do
          @ball ->
            cond do
              x > paddle_x -> free_play(program, x, paddle_x, score, 1)
              x == paddle_x -> free_play(program, x, paddle_x, score, 0)
              x < paddle_x -> free_play(program, x, paddle_x, score, -1)
            end

          @paddle ->
            cond do
              ball_x > x -> free_play(program, ball_x, x, score, 1)
              ball_x == x -> free_play(program, ball_x, x, score, 0)
              ball_x < x -> free_play(program, ball_x, x, score, -1)
            end

          _other ->
            free_play(program, ball_x, paddle_x, score, 0)
        end
      end
    else
      score
    end
  end

  defp run_input_to_output(program, input) do
    program = Intcode.run_input(program, input)
    output = Intcode.get_output(program)
    program = Intcode.clear_outputs(program)
    {program, output, Intcode.halted?(program)}
  end

  defp run_to_output(program) do
    program = Intcode.run(program)
    output = Intcode.get_output(program)
    program = Intcode.clear_outputs(program)
    {program, output, Intcode.halted?(program)}
  end

  # common functions

  defp get_code(input \\ "inputs/day13_input.txt") do
    File.read!(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
