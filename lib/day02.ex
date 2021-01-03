defmodule Day02 do
  @moduledoc """
  --- Day 2:  1202 Program Alarm ---
  """

  @doc """
  --- Part One ---

  An Intcode program is a list of integers separated by commas (like
  1,0,0,3,99). To run one, start by looking at the first integer (called
  position 0). Here, you will find an opcode - either 1, 2, or 99. The opcode
  indicates what to do; for example, 99 means that the program is finished
  and should immediately halt. Encountering an unknown opcode means something
  went wrong.

  Opcode 1 adds together numbers read from two positions and stores the
  result in a third position. The three integers immediately after the opcode
  tell you these three positions - the first two indicate the positions from
  which you should read the input values, and the third indicates the
  position at which the output should be stored.

  For example, if your Intcode computer encounters 1,10,20,30, it should read
  the values at positions 10 and 20, add those values, and then overwrite the
  value at position 30 with their sum.

  Opcode 2 works exactly like opcode 1, except it multiplies the two inputs
  instead of adding them. Again, the three integers after the opcode indicate
  where the inputs and outputs are, not their values.

  Once you're done processing an opcode, move to the next one by stepping
  forward 4 positions.

  For example, suppose you have the following program:

  1,9,10,3,2,3,11,0,99,30,40,50

  For the purposes of illustration, here is the same program split into multiple lines:

  1,9,10,3,
  2,3,11,0,
  99,
  30,40,50

  The first four integers, 1,9,10,3, are at positions 0, 1, 2, and 3.
  Together, they represent the first opcode (1, addition), the positions of
  the two inputs (9 and 10), and the position of the output (3). To handle
  this opcode, you first need to get the values at the input positions:
  position 9 contains 30, and position 10 contains 40. Add these numbers
  together to get 70. Then, store this value at the output position; here,
  the output position (3) is at position 3, so it overwrites itself.
  Afterward, the program looks like this:

  1,9,10,70,
  2,3,11,0,
  99,
  30,40,50

  Step forward 4 positions to reach the next opcode, 2. This opcode works
  just like the previous, but it multiplies instead of adding. The inputs are
  at positions 3 and 11; these positions contain 70 and 50 respectively.
  Multiplying these produces 3500; this is stored at position 0:

  3500,9,10,70,
  2,3,11,0,
  99,
  30,40,50

  Stepping forward 4 more positions arrives at opcode 99, halting the
  program.

  Here are the initial and final states of a few more small programs:

    - 1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2).
    - 2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).
    - 2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).
    - 1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.

  Once you have a working computer, the first step is to restore the gravity
  assist program (your puzzle input) to the "1202 program alarm" state it had
  just before the last computer caught fire. To do this, before running the
  program, replace position 1 with the value 12 and replace position 2 with
  the value 2. What value is left at position 0 after the program halts?
  """

  def run_program_1 do
    get_program()
    |> run_program(0)
    |> Enum.at(0)
  end

  @doc """
  --- Part Two ---

  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode
  program, make sure to start by initializing memory to the program's values.
  A position in memory is called an address (for example, the first value in
  memory is at "address 0").

  Opcodes (like 1, 2, or 99) mark the beginning of an instruction. The values
  used immediately after an opcode, if any, are called the instruction's
  parameters. For example, in the instruction 1,2,3,4, 1 is the opcode; 2, 3,
  and 4 are the parameters. The instruction 99 contains only an opcode and
  has no parameters.

  The address of the current instruction is called the instruction pointer;
  it starts at 0. After an instruction finishes, the instruction pointer
  increases by the number of values in the instruction; until you add more
  instructions to the computer, this is always 4 (1 opcode + 3 parameters)
  for the add and multiply instructions. (The halt instruction would increase
  the instruction pointer by 1, but it halts the program instead.)

  "With terminology out of the way, we're ready to proceed. To complete the
  gravity assist, you need to determine what pair of inputs produces the
  output 19690720."

  The inputs should still be provided to the program by replacing the values
  at addresses 1 and 2, just like before. In this program, the value placed
  in address 1 is called the noun, and the value placed in address 2 is
  called the verb. Each of the two input values will be between 0 and 99,
  inclusive.

  Once the program has halted, its output is available at address 0, also
  just like before. Each time you try a pair of inputs, make sure you first
  reset the computer's memory to the values in the program (your puzzle
  input) - in other words, don't reuse memory from a previous attempt.

  Find the input noun and verb that cause the program to produce the output
  19690720. What is 100 * noun + verb? (For example, if noun=12 and verb=2,
  the answer would be 1202.)
  """

  def find_noun_verb do
    get_program()
    |> run_prog_combo(0, 0)
  end

  defp run_prog_combo(org_prog, noun, verb) do
    prog =
      List.replace_at(org_prog, 1, noun)
      |> List.replace_at(2, verb)
      |> run_program(0)

    if Enum.at(prog, 0) == 19_690_720 do
      100 * Enum.at(prog, 1) + Enum.at(prog, 2)
    else
      verb = verb + 1

      if verb == 100 do
        run_prog_combo(org_prog, noun + 1, 0)
      else
        run_prog_combo(org_prog, noun, verb)
      end
    end
  end

  # common functions

  defp get_program(input \\ "inputs/day02_input.txt") do
    File.read!(input)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
  end

  defp run_program(prog, pc) do
    case Enum.at(prog, pc) do
      99 ->
        prog

      1 ->
        addr1 = Enum.at(prog, pc + 1)
        op1 = Enum.at(prog, addr1)
        addr2 = Enum.at(prog, pc + 2)
        op2 = Enum.at(prog, addr2)
        sum = op1 + op2
        addr3 = Enum.at(prog, pc + 3)
        prog = List.replace_at(prog, addr3, sum)
        run_program(prog, pc + 4)

      2 ->
        addr1 = Enum.at(prog, pc + 1)
        op1 = Enum.at(prog, addr1)
        addr2 = Enum.at(prog, pc + 2)
        op2 = Enum.at(prog, addr2)
        prod = op1 * op2
        addr3 = Enum.at(prog, pc + 3)
        prog = List.replace_at(prog, addr3, prod)
        run_program(prog, pc + 4)
    end
  end
end
