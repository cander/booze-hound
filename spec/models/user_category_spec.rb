require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe UserCategory do
  let(:user) { create(:user) }

  it "should only allow valid categories" do
    UserCategory.create!(user: user, category: "RUM")

    inv = UserCategory.create(user: user, category: "rot gut")
    expect(inv.errors.first.message).to match "not a valid category"

    expect(UserCategory.count).to eq(1)
  end

  it "should return the unique categories across all users" do
    user.add_category("RUM")

    u2 = create(:user, email: "second@test.com")
    u2.add_category("RUM")
    u2.add_category("DOMESTIC WHISKEY")

    u3 = create(:user, email: "third@test.com")
    u3.add_category("RUM")
    u3.add_category("GIN")
    cats = UserCategory.get_user_categories

    expect(cats).to match_array(["DOMESTIC WHISKEY", "RUM", "GIN"])
  end
end
