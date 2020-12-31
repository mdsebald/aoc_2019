defmodule Day05 do
  @moduledoc """
  --- Day 5: ---
  """

  @doc """
  --- Part One ---

  """

  def part_1 do
    get()
  end

  @doc """
  --- Part Two ---

  """
  def part_2 do
    get()
  end

  # common functions

  defp get(input \\ "inputs/day05_input.txt") do
    File.read!(input)
  end
end
