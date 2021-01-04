defmodule Intcode do
  @moduledoc """
  AOC 2019 Intcode program interpreter
  """

  # op codes
  @add  1
  @mult 2
  @input 3
  @output 4
  @jmp_true 5
  @jmp_false 6
  @lessthan 7
  @equals 8
  @halt 99

  defstruct [
    code: [],
    ip: 0,
    inputs: [],
    outputs: [],
    ret_output: false,
    halted: false
  ]

  def run(program) do
    code = program.code
    ip = program.ip

    mode_instr = Enum.at(code, ip)
    instr = rem(mode_instr, 100)
    modes = div(mode_instr, 100)
    mode1 = rem(modes, 10)
    modes = div(modes, 10)
    mode2 = rem(modes, 10)
    modes = div(modes, 10)
    mode3 = rem(modes, 10)

    {addr1, opr1} = get_addr_op(code, ip + 1, mode1)
    {_addr2, opr2} = get_addr_op(code, ip + 2, mode2)
    {addr3, _opr3} = get_addr_op(code, ip + 3, mode3)

    #IO.puts("ip: #{ip}, instr: #{instr}, addr1: #{addr1}, opr1: #{opr1}, opr2: #{opr2}, addr3: #{addr3}")

    case instr do
      @add ->
        code = store(code, addr3, opr1 + opr2)
        run(%Intcode{program | code: code, ip: ip + 4})

      @mult ->
        code = store(code, addr3, opr1 * opr2)
        run(%Intcode{program | code: code, ip: ip + 4})

      @input ->
        [inputs | rem_inputs] = program.inputs
        code  = store(code, addr1, inputs)
        run(%Intcode{program | code: code, ip: ip + 2, inputs: rem_inputs})

      @output ->
        program = %Intcode{program | ip: ip + 2, outputs: [opr1 | program.outputs]}
        if program.ret_output do
          program
        else
          run(program)
        end

      @jmp_true ->
        if opr1 != 0 do
          run(%Intcode{program | ip: opr2})
        else
          run(%Intcode{program | ip: ip + 3})
        end

      @jmp_false ->
        if opr1 == 0 do
          run(%Intcode{program | ip: opr2})
        else
          run(%Intcode{program | ip: ip + 3})
        end

      @lessthan ->
        code =
          if opr1 < opr2 do
            store(code, addr3, 1)
          else
            store(code, addr3, 0)
          end

        run(%Intcode{program | code: code, ip: ip + 4})

      @equals ->
        code =
          if opr1 == opr2 do
            store(code, addr3, 1)
          else
            store(code, addr3, 0)
          end

        run(%Intcode{program | code: code, ip: ip + 4})

      @halt ->
        # If no outputs yet, make up an output using the contents of address 0 (For Day 2)
        if length(program.outputs) == 0 do
          %Intcode{program | outputs: [Enum.at(code, 0)], halted: true}
        else
          %Intcode{program | halted: true}
        end
    end
  end

  defp store(code, addr, val) do
    List.replace_at(code, addr, val)
  end

  # positional mode
  defp get_addr_op(code, ip, 0) do
    addr = Enum.at(code, ip)

    if addr != nil do
      {addr, Enum.at(code, addr)}
    else
      {nil, nil}
    end
  end

  # immediate mode
  defp get_addr_op(code, ip, 1) do
    {0, Enum.at(code, ip)}
  end
end
