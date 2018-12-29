module Adminos::Cropped
  extend ActiveSupport::Concern

  module ClassMethods
    def cropped(as_attribute, coord_attribute = nil)

      define_method "#{as_attribute}_cropped" do
        public_send(as_attribute).variant(combine_options: { crop: public_send("#{as_attribute}_cropped_coord") })
      end

      define_method "#{as_attribute}_attr_coord" do
        coord_attribute || "#{as_attribute}_coord"
      end

      define_method "#{as_attribute}_cropped_coord" do
        public_send(public_send("#{as_attribute}_attr_coord"))
      end
    end
  end
end
