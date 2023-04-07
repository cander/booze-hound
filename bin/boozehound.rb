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
# Maybe client should be a member in the base class?
class LoadStoresCmd
  def call(client, *cities)
    for city in cities do
      puts "Loading stores in #{city}"
      LoadStores.call(client, city)
    end
  end
end

class LoadBottleCmd
  def call(client, category, new_code, old_code)
    puts "Loading inventory for #{category} #{new_code} #{old_code}"
    LoadBottle.call(client, category, new_code, old_code)
  end
end

class UpdateInventoryCmd
  def call(client)
    puts "Updating inventory..."
    puts "There are initially #{OlccInventory.count} inventory records"
    UpdateAllInventory.call(client)
    puts "There are now #{OlccInventory.count} records"
  end
end

CMDS = { loadstores: LoadStoresCmd.new,
         loadbottle: LoadBottleCmd.new,
         updateinventory: UpdateInventoryCmd.new }

cmd = ARGV.shift || usage

c = CMDS[cmd.to_sym] || usage
client = OlccWeb::Client.new(Rails.logger)
c.call(client, *ARGV)

