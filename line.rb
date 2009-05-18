require "errors.rb"

class Line
  attr_reader :label, :op, :arg, :number
  
  def initialize(label, op, arg, number)
    @label, @op, @arg, @number = label, op, arg, number
  end

  def to_s
    "%3i: %-11s %-7s %s" % [@number, @label, @op, @arg]
  end
end

def parse2lines(str)
  lines = []
  str.split( "\n" ).each_with_index do |line, number|
    # remove comment
    i = line.index ";"
    line = line[0..(i-1)] unless i.nil?

    # split line
    parts = line.split
    next if parts.count == 0

    # add nil as label if no label
    parts.unshift( nil ) if ["\t", " "].include? line[0..0]

    # TODO add own errors
    raise UnexpectedStuffAtTheEndError, [parts[3], number + 1] if parts.count > 3
    lines << Line.new( parts[0], parts[1], parts[2], number + 1 )
  end
  lines
end
