defmodule Intcode do
  @moduledoc """
  AOC 2019 Intcode program interpreter
  """

  # op codes
  @add 1
  @mult 2
  @input 3
  @output 4
  @jmp_true 5
  @jmp_false 6
  @lessthan 7
  @equals 8
  @rel_base_offset 9
  @halt 99

  # addressing modes
  @position 0
  @immediate 1
  @offset 2

  defstruct code: [],
            ip: 0,
            inputs: [],
            outputs: [],
            rel_base_offset: 0,
            ret_output: true,
            halted: false

  def new(code, opts \\ []) do
    ret_output = Keyword.get(opts, :ret_output, true)
    inputs = Keyword.get(opts, :inputs, [])
    %Intcode{code: code, ret_output: ret_output, inputs: inputs}
  end

  def set_addr(program, addr, val) do
    %Intcode{program | code: List.replace_at(program.code, addr, val)}
  end

  def run_inputs(program, inputs) do
    run(%Intcode{program | inputs: inputs})
  end

  def run_input(program, input) do
    run(%Intcode{program | inputs: [input]})
  end

  # get the current inputs queue
  def get_inputs(program) do
    program.inputs
  end

  # return the latest output
  def get_output(program), do: hd(program.outputs)

  # return outputs in order, oldest first
  def get_outputs(program), do: Enum.reverse(program.outputs)

  def clear_outputs(program) do
    Map.put(program, :outputs, [])
  end

  def halted?(program), do: program.halted

  def run(program) do
    code = program.code
    ip = program.ip
    offset = program.rel_base_offset

    mode_instr = Enum.at(code, ip)
    instr = rem(mode_instr, 100)
    modes = div(mode_instr, 100)
    mode1 = rem(modes, 10)
    modes = div(modes, 10)
    mode2 = rem(modes, 10)
    modes = div(modes, 10)
    mode3 = rem(modes, 10)

    # IO.puts("ip: #{ip}, offset: #{offset}, instr: #{instr}, modes 1: #{mode1}, 2: #{mode2}, 3: #{mode3}")

    case instr do
      @add ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        {code, addr2} = get_addr(code, ip + 2, offset, mode2)
        opr2 = Enum.at(code, addr2)
        {code, addr3} = get_addr(code, ip + 3, offset, mode3)
        code = store(code, addr3, opr1 + opr2)
        run(%Intcode{program | code: code, ip: ip + 4})

      @mult ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        {code, addr2} = get_addr(code, ip + 2, offset, mode2)
        opr2 = Enum.at(code, addr2)
        {code, addr3} = get_addr(code, ip + 3, offset, mode3)
        code = store(code, addr3, opr1 * opr2)
        run(%Intcode{program | code: code, ip: ip + 4})

      @input ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        [input | rem_inputs] = program.inputs
        code = store(code, addr1, input)
        run(%Intcode{program | code: code, ip: ip + 2, inputs: rem_inputs})

      @output ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        program = %Intcode{program | code: code, ip: ip + 2, outputs: [opr1 | program.outputs]}

        if program.ret_output do
          program
        else
          run(program)
        end

      @jmp_true ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        {code, addr2} = get_addr(code, ip + 2, offset, mode2)
        opr2 = Enum.at(code, addr2)

        if opr1 != 0 do
          run(%Intcode{program | code: code, ip: opr2})
        else
          run(%Intcode{program | code: code, ip: ip + 3})
        end

      @jmp_false ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        {code, addr2} = get_addr(code, ip + 2, offset, mode2)
        opr2 = Enum.at(code, addr2)

        if opr1 == 0 do
          run(%Intcode{program | code: code, ip: opr2})
        else
          run(%Intcode{program | code: code, ip: ip + 3})
        end

      @lessthan ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        {code, addr2} = get_addr(code, ip + 2, offset, mode2)
        opr2 = Enum.at(code, addr2)
        {code, addr3} = get_addr(code, ip + 3, offset, mode3)

        code =
          if opr1 < opr2 do
            store(code, addr3, 1)
          else
            store(code, addr3, 0)
          end

        run(%Intcode{program | code: code, ip: ip + 4})

      @equals ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)
        {code, addr2} = get_addr(code, ip + 2, offset, mode2)
        opr2 = Enum.at(code, addr2)
        {code, addr3} = get_addr(code, ip + 3, offset, mode3)

        code =
          if opr1 == opr2 do
            store(code, addr3, 1)
          else
            store(code, addr3, 0)
          end

        run(%Intcode{program | code: code, ip: ip + 4})

      @rel_base_offset ->
        {code, addr1} = get_addr(code, ip + 1, offset, mode1)
        opr1 = Enum.at(code, addr1)

        run(%Intcode{
          program
          | code: code,
            ip: ip + 2,
            rel_base_offset: program.rel_base_offset + opr1
        })

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
    code = add_mem(code, addr)
    List.replace_at(code, addr, val)
  end

  defp get_addr(code, ip, offset, mode) do
    case mode do
      @immediate ->
        {code, ip}

      @position ->
        addr = Enum.at(code, ip)
        {add_mem(code, addr), addr}

      @offset ->
        addr = Enum.at(code, ip) + offset
        {add_mem(code, addr), addr}
    end
  end

  defp add_mem(code, addr) do
    add_mem = addr + 1 - length(code)

    if add_mem > 0 do
      code ++ for _n <- 1..add_mem, do: 0
    else
      code
    end
  end
end
