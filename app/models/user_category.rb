class UserCategory < ApplicationRecord
  belongs_to :user
  validates :category, inclusion: {in: OlccBottle::CATEGORIES,
                                   message: "%{value} is not a valid category"}

  def self.get_user_categories
    UserCategory.select(:category).distinct.pluck(:category)
  end
end
