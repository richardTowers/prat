#!/usr/bin/env ruby

require 'pg'
require 'optparse'
require_relative 'src/init.rb'
require_relative 'src/hash-object.rb'

options = {}

help = <<HELP
  init  Create an empty Prat repository
HELP

global = OptionParser.new do |opts|
  opts.banner = "Usage: prat.rb [command [options]]"
  opts.separator ""
  opts.separator help
end
subcommands = {
  'init' => OptionParser.new do |opts|
    opts.banner = "Usage: init"
  end,
  'hash-object' => OptionParser.new do |opts|
    opts.banner = "Usage: hash-object [file]"
  end
}
global.order!
command = ARGV.shift
if command.nil?
  puts global.banner
  puts
  puts help
else
  subcommands[command]&.order!

  # TODO - make it so there can be more than one prat repository per postgres instance
  # TODO - allow database credentials
  conn = PG.connect( dbname: 'prat' )

  case command
  when "init"
    init(conn)
  when "hash-object"
    puts hash_object(ARGF.read, conn)
  else
    puts help
  end
end

