class Error < StandardError
  @@msg = ""
  def initialize(arg_and_line_number = [nil, nil])
    @arg, @line_number = *arg_and_line_number
  end

  def to_s
    prefix = "Line #{@line_number}: " if @line_number
    prefix.to_s + "Error, " + ( @@msg % @arg )
  end
end

class UnexpectedStuffAtTheEndError < Error
  @@msg = "unexpected stuff at the end of line ('%s...')"
end
