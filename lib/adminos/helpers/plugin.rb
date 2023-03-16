module Adminos::Helpers::Plugin
  def plugins
    Adminos::Plugins::Base.descendants
  end
end
