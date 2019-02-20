require "active_seo"

module ActiveSeo
  module Loader
    module MobilityMethods
      def has_seo(mobility: defined?(Mobility), **options)
        super(options)
        return unless mobility

        extend Mobility
        translates :seo_title, :seo_keywords, :seo_description if mobility
      end
    end

    module ClassMethods
      include MobilityMethods
    end
  end
end
