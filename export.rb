def mem2mif(mem, config)
  out = []

  addr = config["memory"]["addr size"]
  op = config["memory"]["addr size"]
  size = config["memory"]["size"]

  out << "-- This file was generated by asmax"
  out << "-- http://www.github.com/cypok/asmax"
  out << "-- Moonlighters, 2009"
  out << ""

  out << "depth = #{size};"
  out << "width = #{4 * (addr + op)};"
  
  out << "address_radix = hex;"
  out << "data_radix = hex;"

  out << "content begin"
  0.upto( size-1 ) do |i|
    out << "%5i : %0#{addr + op}x; -- %s" % [i, mem[i][:data], mem[i][:comment]]
  end
  out << "end;"
  out * "\n"
end
