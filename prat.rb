#!/usr/bin/env ruby

require 'pg'
require 'optparse'
require_relative 'src/init.rb'
require_relative 'src/hash-object.rb'
require_relative 'src/update-index.rb'
require_relative 'src/write-tree.rb'
require_relative 'src/commit-tree.rb'

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
  end,
  'update-index' => OptionParser.new do |opts|
    opts.banner = "Usage: update-index --add --cacheinfo mode object_id filename"
    opts.on("-a", "--add") do |a|
      options[:add] = a
    end
    opts.on("-cCACHEINFO", "--cacheinfo=CACHEINFO") do |c|
      options[:cacheinfo] = c
    end
  end,
  'write-tree' => OptionParser.new do |opts|
    opts.banner = "Usage: write-tree"
  end,
  'commit-tree' => OptionParser.new do |opts|
    opts.banner = "Usage: commit-tree"
    opts.on("-pPARENT", "--parent=PARENT") do |p|
      options[:parent] = p
    end
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
  when "update-index"
    update_index(conn, options[:cacheinfo], *ARGV)
  when "write-tree"
    write_tree(conn)
  when "commit-tree"
    tree_id = ARGV.shift
    commit_tree(conn, options[:parent], tree_id, "Richard Towers", ARGF.read)
  else
    puts help
  end
end

