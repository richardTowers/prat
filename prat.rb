#!/usr/bin/env ruby

require 'optparse'
require_relative 'src/init.rb'

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
  case command
  when "init"
    init
  else
    puts help
  end
end

