#!/usr/bin/env ruby
if ARGV.size != 2
  puts "asmax, simple assembler for simple processors"
  puts "usage: ./asmax.rb config.yml file.asm"
end

require "yaml"
require "assembler.rb"

begin
  config = YAML.load( File.open ARGV[0] )
  file = File.open ARGV[1]

  mem_dump = assemble file.read, config

rescue Error => error
  puts error
  exit 1
end
