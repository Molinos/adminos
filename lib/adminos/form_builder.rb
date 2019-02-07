module Adminos
  class FormBuilder < SimpleForm::FormBuilder
    def input(attribute_name, options = {}, &block)
      locale = options.delete(:locale)

      attribute_name = [attribute_name, locale].compact.join('_')

      super(attribute_name, options, &block)
    end
  end
end
