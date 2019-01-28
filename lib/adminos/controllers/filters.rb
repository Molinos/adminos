module Adminos::Controllers::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filters
  end

  class_methods do
    attr_reader :filters

    def add_filter(attribute, *args)
      options = args.extract_options!
      (@filters ||= {})[attribute.to_sym] = options
    end
  end

  def filters
    self.class.filters
  end
end
