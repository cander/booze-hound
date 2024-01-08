class UserCategory # < ApplicationRecord
  # coming soon - will be a real model
  # belongs_to :user

  def self.get_user_categories
    # hard-coded for the moment - will change soon
    ["DOMESTIC WHISKEY", "RUM", "GIN"]
  end
end
