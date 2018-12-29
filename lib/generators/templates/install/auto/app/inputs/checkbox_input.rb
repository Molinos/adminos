class CheckboxInput < SimpleForm::Inputs::BooleanInput
  def input(wrapper_options = nil)
    out = []
    out << %{<div>}
    out << %{ <label class="f-check" for="#{object_name}_#{attribute_name}">}
    out << @builder.input_field("#{attribute_name}", as: :boolean)
    out << %{   <span class="f-check__box"></span>}
    out << %{   <span class="f-check__label">Опубликовано</span>}
    out << %{ </label>}
    out << %{</div>}
    out.join.html_safe
  end
end
