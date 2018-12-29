# <https://github.com/gzigzigzeo/stateful_link>.
module Adminos::StatefulLink::ActionAnyOf#:doc:
  extend ActiveSupport::Concern

  included do
    helper_method :action_any_of?, :extract_controller_and_action, :action_state if respond_to?(:helper_method)
  end

  # Returns true if current controller and action names equals to any of passed.
  # Asterik as action name matches all controller's action.
  #
  # Examples:
  #   <%= "we are in PostsController::index" if action_any_of?("posts#index") %>
  #
  #   <%= "we are not in PostsController::index" unless action_any_of?("posts#index") %>
  #
  #   <% if action_any_of?("posts#index", "messages#index") %>
  #     we are in PostsController or in MessagesController
  #   <% end %>
  #
  def action_any_of?(*actions)
    actions.any? do |sub_ca|
      if sub_ca.present?
        sub_controller, sub_action = extract_controller_and_action(sub_ca)
        ((self.controller_path == sub_controller) || (sub_controller.blank?)) && (self.action_name == sub_action || (sub_action == '' || sub_action == '*'))
      end
    end
  end

  # Extracts controller and action names from a string.
  #
  # Examples:
  #
  #   extract_controller_and_action("posts#index")       # ["posts", "index"]
  #   extract_controller_and_action("admin/posts#index") # ["admin/posts", "index"]
  #   extract_controller_and_action("admin/posts#index") # raises ArgumentError
  #
  def extract_controller_and_action(ca)
    raise ArgumentError, "Pass the string" if ca.nil?
    slash_pos = ca.rindex('#')
    raise ArgumentError, "Invalid action: #{ca}" if slash_pos.nil?
    controller = ca[0, slash_pos]
    action = ca[slash_pos + 1..-1] || ""
    raise ArgumentError, "Invalid action or controller" if action.nil?

    [controller, action]
  end

  # Returns link state related to current controller and action: :inactive, :active or :chosen.
  # A list of active actions is the first argument, chosen actions are the second argument.
  #
  # Examples:
  #   # :active for PostsController::index, :chosen for PostsController::* (except :index),
  #   # :inactive otherwise.
  #   action_state("posts#index", "posts#")
  #
  #   # :active for PostsController::new and PostsController::create, :inactive otherwise.
  #   action_state(["posts#new", "posts#create"])
  #
  #   # :active for PostsController::index, :chosen for MessagesController::* and
  #   # PostsController::* (except :index), :inactive otherwise.
  #   action_state("posts#index", ["posts#", "messages#"])
  #
  def action_state(active, chosen = nil)
    active = active.is_a?(String) ? [active] : active
    chosen = chosen.is_a?(String) ? [chosen] : chosen

    if action_any_of?(*active)
      :active
    elsif !chosen.nil? && action_any_of?(*chosen)
      :chosen
    else
      :inactive
    end
  end
end
