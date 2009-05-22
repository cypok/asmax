#!/usr/bin/env ruby
if ARGV.size != 2
  puts "asmax, simple assembler for simple processors"
  puts "usage: ./asmax.rb config.yml file.asm"
  exit
end

require "yaml"
require "assembler.rb"
require "export.rb"

begin
  config = YAML.load( File.open ARGV[0] )
  file = File.open ARGV[1]

  mem_dump = assemble file.read, config
  file.close

  mif = mem2mif mem_dump, config

  puts mif

rescue Error => error
  puts error
  exit 1
end
