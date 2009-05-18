require "errors.rb"

def parse_arg(line, labels = nil)
  labels ||= {}
  if line.arg =~ /^\d+$/
    line.arg.to_i
  else
    raise InvalidArgumentError, [line.arg, line.number] unless labels.has_key? line.arg
    labels[line.arg]
  end
end

def get_labels(lines)
  labels = {}
  ca = 0 # current address

  lines.each do |line|
    if line.label
      # TODO: check if label is valid identifier
      raise LabelAlreadyDefinedError, [ line.label, line.number ] if labels.has_key? line.label

      case line.op.downcase
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
      case line.op.downcase
      when "orig"
        ca = parse_arg line, labels
      else
        ca += 1
      end
    end
  end
  labels
end
