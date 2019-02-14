module FilterInputs
  class BooleanInput < SimpleForm::Inputs::CollectionSelectInput
    def input(wrapper_options = nil)
      label_method, value_method = detect_collection_methods

      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

      @builder.collection_select(
        filter_attribute_name, collection, value_method, label_method,
        input_options, merged_input_options
      )
    end

    def filter_attribute_name
      "#{attribute_name}_eq"
    end
  end
end
