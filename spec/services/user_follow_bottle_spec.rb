require "rails_helper"
require_relative "../../test/test_helper"

RSpec.describe UserFollowBottle do
  let(:user) { create :user }
  let(:bottle) { create :olcc_bottle }

  it "should fetch inventory for the first follow" do
    client = double("olcc-client")
    expect(client).to receive(:get_item_inventory).and_return([])

    UserFollowBottle.call(client, user, bottle)
  end

  it "should not fetch inventory for a subsequent follow" do
    client = double("olcc-client")
    new_user = create(:user, email: "alice@test.com")
    new_user.follow_bottle(bottle)

    expect { UserFollowBottle.call(client, user, bottle) }.to change { bottle.followers_count }.by 1
    # and we never called the client to fetch inventory
  end
end
