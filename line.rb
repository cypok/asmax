require "errors.rb"

LABEL = /^[_A-Za-z][_A-Za-z0-9]*$/
OP = /^[_A-Za-z][_A-Za-z0-9]*$/
ARG_NUM_DEC = /^[0-9]*$/
ARG_NUM_HEX = /^0x[0-9a-fA-F]+$/

class Line
  attr_reader :label, :op, :arg, :number, :source

  def initialize(label, op, arg, number, source)
    op ||= ""
    arg ||= "0"
    raise InvalidLabelError, [label, number] unless not label or label =~ LABEL
    raise InvalidOpError, [op, number] unless op =~ OP
    raise InvalidArgumentError, [arg, number] unless arg =~ ARG_NUM_DEC or arg =~ ARG_NUM_HEX or arg =~ LABEL
    @label, @op, @arg, @number, @source = label, op, arg, number, source
  end

  def to_s
    "%3i: %-11s %-7s %-5s | %s" % [@number, @label, @op, @arg, @source]
  end
end

def parse_lines(str)
  lines = []
  str.split( "\n" ).each_with_index do |line, number|
    # remove comment
    i = line.index ";"
    line = line[0..(i-1)] unless i.nil?

    # split line
    parts = line.downcase.split
    next if parts.count == 0

    # add nil as label if no label
    parts.unshift( nil ) if ["\t", " "].include? line[0..0]

    raise UnexpectedStuffAtTheEndError, [parts[3], number + 1] if parts.count > 3
    lines << Line.new( parts[0], parts[1], parts[2], number + 1, line )
  end
  lines
end
