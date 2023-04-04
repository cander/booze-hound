#!/usr/bin/env ruby
# Simple script/command to invoke some functions from the command line.
# Should probably be moved to lib/Cli and expanded
require_relative "../config/environment"

def usage
  puts "Use it right, dummy"
  exit 1
end

# Notes on command pattern: commands could have descriptions to be printed
# by usage. The invocation of `call` could catch ArgumentError and print the
# usage for that command. That catch could be in base class
class LoadStoresCmd
  def call(*cities)
    client = OlccWeb::Client.new(Rails.logger)
    for city in cities do
      puts "Loading stores in #{city}"
      LoadStores.call(client, city)
    end
  end
end

class LoadBottleCmd
  def call(category, new_code, old_code)
    puts "TBD - LoadBottle: #{category} #{new_code} #{old_code}"
  end
end

CMDS = { loadstores: LoadStoresCmd.new,
         loadbottle: LoadBottleCmd.new }

cmd = ARGV.shift || usage

c = CMDS[cmd.to_sym] || usage
c.call(*ARGV)

