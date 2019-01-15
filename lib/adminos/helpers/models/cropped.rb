module Adminos::Cropped
  extend ActiveSupport::Concern

  module ClassMethods
    def cropped(as_attribute, *args)
      options = args.extract_options!

      version = options.delete(:version) || :default
      coord_attribute = options.delete(:coord_attribute) || "#{as_attribute}_coord"

      define_method "#{version}_#{as_attribute}_cropped" do
        public_send(as_attribute).variant(combine_options: { crop: public_send("#{version}_#{as_attribute}_coord") })
      end

      define_method "#{version}_#{as_attribute}_attr_coord" do
        coord_attribute
      end

      define_method "#{version}_#{as_attribute}_coord" do
        public_send(public_send("#{version}_#{as_attribute}_attr_coord"))
      end
    end
  end
end
