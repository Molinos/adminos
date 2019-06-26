class CarrierwaveInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    version = input_html_options.delete(:preview_version) || :preview
    is_image = input_html_options.delete(:image) || false

    out = []
    out << %{<div class="f-file">}
    out << @builder.hidden_field("#{attribute_name}_cache")
    out << %{  <label class="f-file__selection js-file">}
    out << %{    <span class="f-file__button">#{I18n.t('labels.admin.choose')}</span>}
    out << @builder.file_field(attribute_name, input_html_options)
    out << %{    <span class="f-file__selected"></span>}
    out << %{  </label>}
    out << preview(is_image, version) if object.send("#{attribute_name}?")
    out << remove_field if object.send("#{attribute_name}?")
    out << %{</div>}
    out.join.html_safe
  end

  private

  def remove_field
    out = []
    out << %{<div class="f-file__remove">}
    out << @builder.input_field("remove_#{attribute_name}", as: :boolean)
    out << %{  <label class="f-check">}
    out << %{    <span class="f-check__box"></span>}
    out << %{    <span class="f-check__label">#{I18n.t('labels.admin.destroy')}</span>}
    out << %{  </label>}
    out << %{</div>}
    out.join
  end

  def preview(is_image, version)
    out = []
    out << %{<div class="f-file__preview">}
    out << %(  <a target="_blank" href="#{object.send(attribute_name).url}">)
    if is_image
      return nil if object.send(attribute_name).nil?
      out << template.image_tag(object.send(attribute_name).tap { |o| break o.send(version) if version }.send('url'))
    else
      out << template.link_to(basename, object.send(attribute_name).url, target: '_blank')
    end
    out << %(  </a>)
    out << %{</div>}
    out.join
  end

  def basename
    File.basename(object.send(attribute_name).file.path)
  end
end
