require "errors.rb"
require "line.rb"

def parse_arg_ex(arg, line_number, labels)
  labels ||= {}
  # trying dec
  if arg =~ ARG_NUM_DEC
    arg.to_i
  # trying hex
  elsif arg =~ ARG_NUM_HEX
    arg.to_i( 16 )
  else
    # trying to find math expression
    [
      [ "+", lambda {|x, y| x + y } ],
      [ "-", lambda {|x, y| x - y } ],
      [ "*", lambda {|x, y| x * y } ]
    ].each do |char, func|
      i = arg.index char
      unless i.nil?
        return func.call( 
                  parse_arg_ex( arg[0..i-1], line_number, labels ),
                  parse_arg_ex( arg[i+1..-1], line_number, labels )
                 )
      end
    end

    raise InvalidArgumentError, [arg, line_number] unless labels.has_key? arg
    labels[arg]
  end
end

def parse_arg(line, labels)
  parse_arg_ex line.arg, line.number, labels
end

def find_labels(lines)
  labels = {}
  ca = 0 # current address

  lines.each do |line|
    if line.label
      raise LabelAlreadyDefinedError, [ line.label, line.number ] if labels.has_key? line.label

      case line.op
      when "orig"
        labels[line.label] = ca
        ca = parse_arg line, labels
      when "equ"
        labels[line.label] = parse_arg line, labels
      else
        labels[line.label] = ca
        ca += 1
      end
    else
      case line.op
      when "orig"
        ca = parse_arg line, labels
      else
        ca += 1
      end
    end
  end
  labels
end
