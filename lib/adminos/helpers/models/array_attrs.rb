module Adminos::ArrayAttrs
  extend ActiveSupport::Concern

  module ClassMethods
    def array_attrs(*args)
      options = args.extract_options!

      args.each do |name|
        define_method :"#{name}_to_a" do
          value = send(name)
          split = value.split("\n") || []
          values = split.map { |value| value.strip }
        end
      end
    end
  end
end
