module GlobalizeActiontext
  module ActionText
    def setup_translates!(options)
      super

      self.after_initialize do
        reflect_has_one = self.class.reflect_on_all_associations(:has_one)
        rich_text_attributes = reflect_has_one.map(&:name).map { |name| name.to_s.gsub('rich_text_', '') }.compact

        self.class.translation_class.class_eval do
          rich_text_attributes.each do |rich_text_attribute|
            attribute rich_text_attribute
            has_rich_text rich_text_attribute
            define_method "#{rich_text_attribute}=" do |value|
              send(rich_text_attribute).body = value

              return unless public_send(rich_text_attribute).changed?

              attribute_will_change! rich_text_attribute
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.singleton_class.prepend(GlobalizeActiontext::ActionText)
