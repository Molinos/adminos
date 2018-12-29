require 'simple_form'

SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.
  config.wrappers :default, class: :input,
    hint_class: :field_with_hint, error_class: :field_with_errors do |b|
    ## Extensions enabled by default
    # Any of these extensions can be disabled for a
    # given input by passing: `f.input EXTENSION_NAME => false`.
    # You can make any of these extensions optional by
    # renaming `b.use` to `b.optional`.

    # Determines whether to use HTML5 (:email, :url, ...)
    # and required attributes
    b.use :html5

    # Calculates placeholders automatically from I18n
    # You can also pass a string as f.input :placeholder => "Placeholder"
    b.use :placeholder

    ## Optional extensions
    # They are disabled unless you pass `f.input EXTENSION_NAME => :lookup`
    # to the input. If so, they will retrieve the values from the model
    # if any exists. If you want to enable the lookup for any of those
    # extensions by default, you can change `b.optional` to `b.use`.

    # Calculates maxlength from length validations for string inputs
    b.optional :maxlength

    # Calculates pattern from format validations for string inputs
    b.optional :pattern

    # Calculates min and max from length validations for numeric inputs
    b.optional :min_max

    # Calculates readonly automatically from readonly attributes
    b.optional :readonly

    ## Inputs
    b.use :label_input
    b.use :hint,  wrap_with: { tag: :span, class: :hint }
    b.use :error, wrap_with: { tag: :span, class: :error }
  end

  config.wrappers :bootstrap, tag: 'div', class: 'control-group', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :prepend, tag: 'div', class: "control-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :append, tag: 'div', class: "control-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :auth, tag: 'div', class: 'form__field', error_class: 'form__field--error' do |b|
    b.use :html5

    b.use :placeholder

    b.use :input, class: 'form-control'

    b.use :error, wrap_with: { tag: 'span', class: 'form__comment' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'form__comment' }
  end

  config.wrappers :admin, tag: 'div', class: 'f-field', error_class: 'f-field--error' do |b|
    b.use :html5

    b.wrapper tag: 'div', class: 'f-field__label' do |b1|
      b1.use :label, class: 'f-label'
    end

    b.wrapper tag: 'div', class: 'f-field__container' do |b2|
      b2.use :input, class: 'form-control'

      b2.use :error, wrap_with: { tag: 'span', class: 'f-comment' }
      b2.use :hint,  wrap_with: { tag: 'span', class: 'f-comment' }
    end
  end

  config.wrappers :select, tag: 'div', class: 'f-field', error_class: 'f-field--error' do |b|
    b.use :html5

    b.wrapper tag: 'div', class: 'f-field__label' do |b1|
      b1.use :label, class: 'f-label'
    end

    b.wrapper tag: 'div', class: 'f-field__container' do |b2|
      b2.use :input, class: 'custom-select'

      b2.use :error, wrap_with: { tag: 'span', class: 'f-comment' }
      b2.use :hint,  wrap_with: { tag: 'span', class: 'f-comment' }
    end
  end

  config.wrappers :check, tag: 'div', class: 'f-field f-field--checks', error_class: 'f-field--error' do |b|
    b.use :html5

    b.wrapper tag: 'div', class: 'f-field__container' do |b1|
      b1.wrapper tag: 'label', class: 'f-check' do |b2|
        b2.use :input

        b2.wrapper tag: 'span', class: 'f-check__box' do
        end

        b2.wrapper tag: 'span', class: 'f-check__label' do |b3|
          b3.use :label_text
        end
      end

      b1.use :error, wrap_with: { tag: 'span', class: 'f-comment' }
      b1.use :hint,  wrap_with: { tag: 'span', class: 'f-comment' }
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap

  # Define the way to render check boxes / radio buttons with labels.
  # Defaults to :nested for bootstrap config.
  #   :inline => input + label
  #   :nested => label > input
  config.boolean_style = :inline

  # Default class for buttons
  config.button_class = 'btn'

  # Method used to tidy up errors.
  # config.error_method = :first

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert alert-error'

  # ID to add for error notification helper.
  # config.error_notification_id = nil

  # Series of attempts to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can define the class to use on all collection wrappers. Defaulting to none.
  # config.collection_wrapper_class = nil

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to :span. Please note that when using :boolean_style = :nested,
  # SimpleForm will force this option to be a label.
  # config.item_wrapper_tag = :span

  # You can define a class to use in all item wrappers. Defaulting to none.
  # config.item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  config.label_text = lambda { |label, required, explicit_label| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  config.label_class = 'control-label'

  # You can define the class to use on all forms. Default is simple_form.
  # config.form_class = :simple_form

  # You can define which elements should obtain additional classes
  # config.generate_additional_classes_for = [:wrapper, :label, :input]

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Tell browsers whether to use default HTML5 validations (novalidate option).
  # Default is enabled.
  config.browser_validations = false

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # Default size for text inputs.
  # config.default_input_size = 50

  # When false, do not use translations for labels.
  # config.translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache SimpleForm inputs discovery
  # config.cache_discovery = !Rails.env.development?
end
