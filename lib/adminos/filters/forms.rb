module Adminos
  module Filters
    class FormBuilder < ::Adminos::FormBuilder
      map_type :date_range, to: SimpleForm::Inputs::DateTimeInput
      map_type :numeric, to: SimpleForm::Inputs::NumericInput

      def filter(attribute_name, options = {})
        if attribute_name.present? && options[:as] ||= input_type(attribute_name)
          template.concat input(attribute_name, options)
        end
      end

      def input_type(attribute_name)
        column = find_attribute_column(attribute_name)
        input_type = default_input_type(attribute_name, column, {})

        case input_type
        when :date, :datetime
          :date_range
        when :string, :text, :jsonb, :email
          :string
        when :integer, :float, :decimal
          :numeric
        when :boolean
          :boolean
        end
      end

      def klass
        @object.object
      end

      def find_attribute_column(attribute_name)
        if klass.respond_to?(:type_for_attribute) && klass.has_attribute?(attribute_name)
          klass.type_for_attribute(attribute_name.to_s)
        elsif klass.respond_to?(:column_for_attribute) && klass.has_attribute?(attribute_name)
          klass.column_for_attribute(attribute_name)
        end
      end

      def find_mapping(input_type)
        if mapping = self.class.mappings[input_type]
          mapping_override(mapping) || mapping
          camelized = "#{input_type.to_s.camelize}Input"

          attempt_mapping(camelized, FilterInputs) ||
            attempt_mapping_with_custom_namespace(camelized) ||
            attempt_mapping(camelized, Object) ||
            attempt_mapping(camelized, self.class) ||
            raise("No input found for #{input_type}")
        end
      end
    end
  end
end
