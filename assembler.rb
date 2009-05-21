require "line.rb"
require "label.rb"

def assemble(source, config)
  lines = parse_lines source
  labels = find_labels lines

  ca = 0
  memory = []
  config["memory"]["size"].times do
    memory << {:data => 0, :comment => ""}
  end

  addr_instr_order = config["memory"]["address then instruction"]

  op_size = 16**config["memory"]["op size"]
  addr_size = 16**config["memory"]["addr size"]

  lines.each do |line|
    case line.op
    when "orig"
      ca = parse_arg line, labels
    when "equ"
      ca += 1
    when "con"
      memory[ca][:comment] = line.source
      memory[ca][:data] = parse_arg line, labels
      ca += 1
    else
      memory[ca][:comment] = line.source
      
      arg = parse_arg line, labels
      op = config["instructions"][line.op]
      raise UnknownInstructionError, [line.op, line.number] unless op

      raise TooBigInstructionError, [[ op, op_size ], line.number] if op >= op_size
      raise TooBigArgumentError, [[ arg, addr_size ], line.number] if arg >= addr_size
      
      memory[ca][:data] = if addr_instr_order
        op + arg * op_size
      else
        arg + op * addr_size
      end

      ca += 1
    end
  end
  memory
end
