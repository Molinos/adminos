module ActionView
  module Helpers
    class FormBuilder
      def globalize_fields_for(locale, *args, &proc)
        raise ArgumentError, "Missing block" unless block_given?
        @globalize_index = @globalize_index ? @globalize_index + 1 : 1
        object_name = "#{@object_name}[translations_attributes][#{@globalize_index}]"
        object = @object.translation_for locale
        @template.concat @template.hidden_field_tag("#{object_name}[id]", object ? object.id : "")
        @template.concat @template.hidden_field_tag("#{object_name}[locale]", locale)
        if @template.respond_to? :simple_fields_for
          @template.simple_fields_for(object_name, object, *args, &proc)
        else
          @template.fields_for(object_name, object, *args, &proc)
        end
      end
    end
  end
end
