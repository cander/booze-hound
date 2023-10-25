module OlccBottleHelper
  def category_select(form)
    labels_values = []
    OlccBottle::CATEGORIES.each do |cap_cat|
      labels_values << [cap_cat.titleize, cap_cat]
    end

    form.select :category, labels_values
  end
end
