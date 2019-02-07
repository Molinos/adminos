module Adminos
  module SimpleFormExtraBase
    # Find reflection name when available, otherwise use attribute
    def reflection_or_attribute_name
      @reflection_or_attribute_name ||= reflection ? reflection.name : attribute_name
      @reflection_or_attribute_name.to_s.gsub(/_(#{I18n.available_locales.join('|')})/, '')
    end
  end
end


SimpleForm::Inputs::Base.prepend(Adminos::SimpleFormExtraBase)
