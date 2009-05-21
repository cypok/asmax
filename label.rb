require "errors.rb"
require "line.rb"

def parse_arg(line, labels)
  labels ||= {}
  if line.arg =~ ARG_NUM_DEC
    line.arg.to_i
  elsif line.arg =~ ARG_NUM_HEX
    line.arg.to_i( 16 )
  else
    raise InvalidArgumentError, [line.arg, line.number] unless labels.has_key? line.arg
    labels[line.arg]
  end
end

def find_labels(lines)
  labels = {}
  ca = 0 # current address

  lines.each do |line|
    if line.label
      # TODO: check if label is valid identifier
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
