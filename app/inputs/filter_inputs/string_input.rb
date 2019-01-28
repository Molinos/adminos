module FilterInputs
  class StringInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options = nil)
      @wrapper_options = wrapper_options
      out = []
      out << select_html
      out << input_html
      out.join.html_safe
    end

    def select_html
      template.select_tag '', template.options_for_select(filter_options, current_filter), class: 'select_filter form-control'
    end

    def input_html
      merged_input_options = merge_wrapper_options(input_html_options, @wrapper_options)
      @builder.text_field current_filter, merged_input_options.merge(class: 'form-control')
    end

    def current_filter
      @current_filter ||= begin
        attributes = filters.map { |f| "#{attribute_name}_#{f}" }
        attributes.detect { |m| object.public_send m } || attributes.first
      end
    end

    def label_html
    end

    def filter_options
      filters.map do |filter|
        [filter, "#{attribute_name}_#{filter}"]
      end
    end

    def filters
      %w(cont eq start end)
    end
  end
end
