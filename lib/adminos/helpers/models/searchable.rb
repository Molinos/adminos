module Adminos::Searchable
  extend ActiveSupport::Concern

  class_methods do
    def searchable(*args)
      include Adminos.configuration.search_engine
    end
  end
end
