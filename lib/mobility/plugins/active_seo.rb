module Mobility
  module Plugins
    module ActiveSeo
      def self.apply(attributes, option)
        return unless option
        backend_class, model_class = attributes.backend_class, attributes.model_class

        seo_attribute_names = attributes.names.map do |attr|
          attr.gsub('seo_', '') if attr.include?('seo_')
        end.compact

        return if seo_attribute_names.blank?

        ::ActiveSeo::SeoMetum.class_eval do
          extend Mobility

          translates *seo_attribute_names
        end
      end
    end
  end
end
