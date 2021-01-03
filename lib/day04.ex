defmodule Day04 do
  @moduledoc """
  --- Day 4: Secure Container ---
  """

  @doc """
  --- Part One ---
  You arrive at the Venus fuel depot only to discover it's protected by a
  password. The Elves had written the password on a sticky note, but someone
  threw it out.

  However, they do remember a few key facts about the password:

    - It is a six-digit number.
    - The value is within the range given in your puzzle input.
    - Two adjacent digits are the same (like 22 in 122345).
    - Going from left to right, the digits never decrease; they only ever
      increase or stay the same (like 111123 or 135679).

  Other than the range rule, the following are true:

    - 111111 meets these criteria (double 11, never decreases).
    - 223450 does not meet these criteria (decreasing pair of digits 50).
    - 123789 does not meet these criteria (no double).

  How many different passwords within the range given in your puzzle input
  meet these criteria?

  Your puzzle input is 246540-787419.
  """

  def count_valid_passwords_1 do
    246_540..787_419
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.filter(fn pw ->
      {_last_digit, increasing, double_digits} =
        Enum.reduce_while(pw, {nil, false, false}, fn pw_digit, {last_digit, _incr, dbl} ->
          cond do
            last_digit == nil -> {:cont, {pw_digit, false, false}}
            pw_digit > last_digit -> {:cont, {pw_digit, true, dbl}}
            pw_digit == last_digit -> {:cont, {pw_digit, true, true}}
            pw_digit < last_digit -> {:halt, {pw_digit, false, dbl}}
          end
        end)

      increasing and double_digits
    end)
    |> Enum.count()
  end

  @doc """
  --- Part Two ---

  An Elf just remembered one more important detail: the two adjacent matching
  digits are not part of a larger group of matching digits.

  Given this additional criterion, but still ignoring the range rule, the
  following are now true:

    - 112233 meets these criteria because the digits never decrease and all
      repeated digits are exactly two digits long.
    - 123444 no longer meets the criteria (the repeated 44 is part of a
      larger group of 444).
    - 111122 meets the criteria (even though 1 is repeated more than twice,
      it still contains a double 22).

  How many different passwords within the range given in your puzzle input
  meet all of the criteria?
  """

  def count_valid_passwords_2 do
    # [112233, 123444, 111122]
    246_540..787_419
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.filter(fn pw ->
      {_last_digit, incr, dbl, same} =
        Enum.reduce_while(pw, {nil, false, false, 0}, fn pw_digit,
                                                         {last_digit, _incr, dbl, same} ->
          cond do
            last_digit == nil ->
              {:cont, {pw_digit, false, false, 1}}

            pw_digit > last_digit ->
              if same == 2 do
                {:cont, {pw_digit, true, true, 1}}
              else
                {:cont, {pw_digit, true, dbl, 1}}
              end

            pw_digit == last_digit ->
              {:cont, {pw_digit, true, dbl, same + 1}}

            pw_digit < last_digit ->
              {:halt, {pw_digit, false, dbl, same}}
          end
        end)

      incr and (dbl or same == 2)
    end)
    |> Enum.count()
  end

  # common functions
end
