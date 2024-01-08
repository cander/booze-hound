class DailyUpdate < ApplicationService
  def initialize(client, writer)
    @client = client
    @writer = writer
  end

  def call
    count = OlccBottle.count
    UserCategory.get_user_categories.each do |cat|
      @writer.write "Updating #{cat}\n"
      UpdateCategoryBottles.call(@client, cat)
    end
    @writer.write "Found #{OlccBottle.count - count} new bottles\n"

    count = OlccInventory.count
    UpdateAllInventory.call(@client)
    @writer.write "There are now #{OlccInventory.count - count} new inventory records\n"
  end
end
