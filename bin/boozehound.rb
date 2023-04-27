#!/usr/bin/env ruby
# Simple script/command to invoke some functions from the command line.
# Should probably be moved to lib/Cli and expanded
require_relative "../config/environment"
require "csv"

def usage
  puts "Use it right, dummy"
  exit 1
end

# Notes on command pattern: commands could have descriptions to be printed
# by usage. The invocation of `call` could catch ArgumentError and print the
# usage for that command. That catch could be in base class
# Maybe client should be a member in the base class?

class FetchBottlesCsvCmd
  def call(client, category, file_name)
    puts "Fetching all #{category} bottles as CSV"
    bots = client.get_category_bottles(category)
    puts "Found #{bots.size} bottles"
    CSV.open(file_name, "w",
      write_headers: true, headers: bots.first.members) do |csv|
      bots.each { |b| csv << b.deconstruct }
    end
  end
end

class LoadBottleCmd
  def call(client, category, new_code, old_code)
    puts "Loading inventory for #{category} #{new_code} #{old_code}"
    LoadBottle.call(client, category, new_code, old_code)
  end
end

class LoadBottlesCsvCmd
  def call(client, file_name)
    puts "Loading bottles from #{file_name}"
    rows = CSV.read(file_name, headers: true).map(&:to_h)
    # TODO: be more selective, don't step of followed flag
    OlccBottle.upsert_all(rows)
    puts "Processed #{rows.size} bottles"
  end
end

class LoadStoresCmd
  def call(client, *cities)
    cities.each do |city|
      puts "Loading stores in #{city}"
      LoadStores.call(client, city)
    end
  end
end

class UpdateCategoryCmd
  def call(client, category)
    puts "Updating all bottles in #{category}..."
    puts "There are now #{OlccBottle.count} bottles"
    UpdateCategoryBottles.call(client, category)
    puts "There are now #{OlccBottle.count} bottles"
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

CMDS = {fetchbottlescsv: FetchBottlesCsvCmd.new,
        loadstores: LoadStoresCmd.new,
        loadbottle: LoadBottleCmd.new,
        loadbottlescsv: LoadBottlesCsvCmd.new,
        updatecategory: UpdateCategoryCmd.new,
        updateinventory: UpdateInventoryCmd.new}

cmd = ARGV.shift || usage

c = CMDS[cmd.to_sym] || usage
client = OlccWeb::Client.new(Rails.logger)
c.call(client, *ARGV)
