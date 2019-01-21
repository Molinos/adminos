module Adminos
  class Configuration
    attr_accessor :search_engine

    def initialize
      @search_engine = Adminos::Search::PgSearch
    end
  end
end
