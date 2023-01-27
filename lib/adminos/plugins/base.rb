module Adminos
  module Plugins
    class Base
      def self.name
        raise NotImplementedError.new('method name is not defined')
      end
    end
  end
end

