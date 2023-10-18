module BottleEventHelper
  def show_event(evt)
    # arguably, this case says we should have polymorphism
    case evt.event_type
    when "NEW BOTTLE"
      "New bottle"
    when "NEW INVENTORY"
      store = OlccStore.find(evt.details["store_num"])
      # prepend is a trick/hack to keep the HTML from being escaped incorrectly
      link_to(store.name, store).prepend("arrived at ")
    when "PRICE CHANGE"
      delta = evt.details["bottle_price"]
      "price changed from #{number_to_currency(delta[0])} to #{number_to_currency(delta[1])}"
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
