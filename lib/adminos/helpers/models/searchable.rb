module Adminos::Searchable
  extend ActiveSupport::Concern
  include Adminos.configuration.search_engine

  included do
    self.setup_search
  end
end
