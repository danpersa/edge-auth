module IdentitiesHelper

  def display_all_error_messages(object, method)
    list_items = object.errors[method].map { |msg| msg }
    list_items.join(',').html_safe
  end
end
