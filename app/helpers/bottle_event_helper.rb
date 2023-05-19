module BottleEventHelper
  def show_event(evt)
    # arguably, this case says we should have polymorphism
    case evt.event_type
    when "NEW BOTTLE"
      "New bottle"
    when "NEW INVENTORY"
      store = OlccStore.find(evt.details["store_num"])
      "arrived at #{store.name}"
    when "PRICE CHANGE"
      delta = evt.details["bottle_price"]
      "price changed from $#{delta[0]} to $#{delta[1]}"
    when "DESCRIPTION CHANGE"
      changes = evt.details.keys.first(3)
      "description changed - #{changes.join(",")}"
    else
      evt.event_type
    end
  end

  def format_date(evt)
    evt.created_at.strftime("%e %b %Y")
  end
end
