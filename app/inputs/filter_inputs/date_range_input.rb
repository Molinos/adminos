module FilterInputs
  class DateRangeInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options = nil)
      @wrapper_options = wrapper_options
      out = []

      out << input_html
      out.join.html_safe
    end


    def input_html
      merged_input_options = merge_wrapper_options(input_html_options, @wrapper_options)
      [
        @builder.text_field(gt_input_name, merged_input_options.merge(placeholder: gt_input_placeholder, class: 'date-picker form-control')),
        @builder.text_field(lt_input_name, merged_input_options.merge(placeholder: lt_input_placeholder, class: 'date-picker form-control'))
      ].join("\n").html_safe
    end


    def gt_input_name
      "#{attribute_name}_gteq"
    end
    alias :input_name :gt_input_name


    def lt_input_name
      "#{attribute_name}_lteq"
    end

    def gt_input_placeholder
      'От'
    end

    def lt_input_placeholder
      'До'
    end
  end
end
