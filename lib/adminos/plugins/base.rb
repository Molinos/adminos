module Adminos
  module Plugins
    class Base
      def self.title
        raise NotImplementedError.new('method name is not defined')
      end
    end
  end
end

