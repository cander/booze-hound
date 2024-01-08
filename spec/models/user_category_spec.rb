require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe UserCategory do
  it "should return the hard-coded categories" do
    # In the future, set up UserCategories for several Users
    cats = UserCategory.get_user_categories

    expect(cats).to match_array(["DOMESTIC WHISKEY", "RUM", "GIN"])
  end
end
