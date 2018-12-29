# <http://stackoverflow.com/questions/1183506/make-blank-params-nil#1186265>.
module Adminos::IfBlankSetToNilParams
  extend ActiveSupport::Concern

  module ClassMethods
    def if_blank_set_to_nil_params(*args)
      options = args.extract_options!
      attrs = args.first
      fail ArgumentError if attrs.blank?
      attrs = [attrs] unless attrs.is_a?(Array)

      before_validation do |object|
        attrs.each do |attr_name|
          object[attr_name] = nil if object[attr_name].blank?
        end
      end
    end
  end
end
