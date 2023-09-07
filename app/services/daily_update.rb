class DailyUpdate < ApplicationService
  def initialize(client, writer)
    @client = client
    @writer = writer
  end

  def call
    count = OlccBottle.count
    # TODO: the next time we add a category, iterate over a list instead
    UpdateCategoryBottles.call(@client, "DOMESTIC WHISKEY")
    UpdateCategoryBottles.call(@client, "RUM")
    @writer.write "Found #{OlccBottle.count - count} new bottles\n"

    count = OlccInventory.count
    UpdateAllInventory.call(@client)
    @writer.write "There are now #{OlccInventory.count - count} new inventory records\n"
  end
end
