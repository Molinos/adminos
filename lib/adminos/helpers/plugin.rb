module Adminos::Helpers::Plugin
  def plugins_name
    Adminos::Plugins::Base.descendants.map(&:name)
  end
end
