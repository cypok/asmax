#!/usr/bin/env ruby
if ARGV.size != 2
  puts "asmax, simple assembler for simple processors"
  puts "usage: ./asmax.rb config.yml file.asm"
end

require "pp"
require "yaml"
require "line.rb"
require "label.rb"

begin
  config = YAML.load( File.open ARGV[0] )
  file = File.open ARGV[1]

  lines = parse2lines file.read
  lines.each { |l| puts l }
  
  labels = get_labels lines
  pp labels

rescue Error => error
  puts
  puts error
  exit 1
end
