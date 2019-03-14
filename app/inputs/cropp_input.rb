class CroppInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    @version = input_html_options.delete(:version) || :default
    @coord_attribute = input_html_options.delete(:coord_attribute) || object.send("#{@version}_#{attribute_name}_attr_coord")

    out = []
    out << %{<div class="f-file">}
    out << %{  <label class="f-file__selection js-file">}
    out << %{    <span class="f-file__button">Выбрать</span>}
    out << @builder.file_field(attribute_name, input_html_options)
    out << @builder.hidden_field(@coord_attribute)
    out << %{    <span class="f-file__selected"></span>}
    out << %{  </label>}
    out << %{</div>}
    out << preview

    out.join.html_safe
  end

  def preview
    return unless object.send(attribute_name).attached?
    out = []

    aspect_ratio = input_html_options.delete(:aspect_ratio) || '16/9'
    aspect_ratio = aspect_ratio.split('/').map(&:to_f)
    aspect_ratio = aspect_ratio[0] / aspect_ratio[1]

    out << %{<div class="row"><div class="col-md-8"><div class="img-container">}

    out << template.image_tag(object.send(attribute_name), data: { aspect_ratio: aspect_ratio, preview: ".#{@version}_#{attribute_name}_preview", toggle: 'cropp', coord: @coord_attribute })

    out << %{</div></div><div class="col-md-4">}
    out << %{<div class="cropper-dimensions">}
    out << %{<div class="field">}
    out << template.label_tag(:width, 'Ширина', class: 'control-label')
    out << template.number_field_tag(:width, nil, class: 'form-control')
    out << %{</div>}
    out << %{<div class="field">}

    out << template.label_tag(:height, 'Высота', class: 'control-label')
    out << template.number_field_tag(:height, nil, class: 'form-control')
    out << %{</div>}

    out << %{</div>}
    out << %{<div class="docs-preview clearfix">}
    out << %{<div class="img-preview preview-lg #{@version}_#{attribute_name}_preview"></div>}
    out << cropped

    out << %{</div></div></div>}
    out.join
  end

  def cropped
    return if @coord_attribute.blank?

    out = []
    out << %{<div class="preview-cropped"><figure class="figure">}

    out << template.image_tag(object.send("#{@version}_#{attribute_name}_cropped"))

    out << %{<figcaption class="figure-caption text-center">Cropped image</figcaption></figure></div>}
    out.join
  end
end
