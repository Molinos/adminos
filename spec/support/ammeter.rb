require 'action_controller'
require 'action_view'
require 'ammeter/init'

module Ammeter
  module RSpec
    module Rails
      # Delegates to Rails::Generators::TestCase to work with RSpec.
      module GeneratorExampleGroup
        delegate :capture, to: Ammeter::OutputCapturer
      end
    end
  end
end
