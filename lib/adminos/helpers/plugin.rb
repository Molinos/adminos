module Adminos::Helpers::Plugin
  def plugin_names
    Adminos::Plugins::Base.descendants.map(&:name)
  end
end
