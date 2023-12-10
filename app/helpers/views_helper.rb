module ViewsHelper
  def flash_type_class(flash_type)
    # Takes flash type and returns the correct CSS classes for styling the badge
    case flash_type
    when "notice"
      "border-dark text-bg-light"
    when "alert"
      "border-dark text-bg-danger"
    end
  end
end
