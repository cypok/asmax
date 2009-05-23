class Error < StandardError
  def initialize(arg_and_line_number = [nil, nil])
    @arg, @line_number = *arg_and_line_number
  end

  def to_s
    prefix = "Line #{@line_number}: " if @line_number
    prefix.to_s + "Error, " + ( msg % @arg )
  end
end

class UnexpectedStuffAtTheEndError < Error
  def msg; "unexpected stuff at the end of line ('%s...')" end
end

class LabelAlreadyDefinedError < Error
  def msg; "label '%s' is already defined" end
end

class InvalidArgumentError < Error
  def msg; "argument '%s' is neither integer nor label" end
end

class InvalidLabelError < Error
  def msg; "label '%s' is invalid" end
end

class InvalidOpError < Error
  def msg; "instruction '%s' is invalid" end
end

class TooBigInstructionError < Error
  def msg; "instruction code (%i) is bigger or equal than maximum (%i)" end
end

class TooBigArgumentError < Error
  def msg; "address (%i) is bigger or equal than maximum (%i)" end
end

class UnknownInstructionError < Error
  def msg; "unknown instruction '%s'" end
end
