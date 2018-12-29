module Adminos::Helpers::Admin
  def admin_index_path(resource_class)
    url_parts = [:admin, resource_class.name.pluralize.underscore]
    url_parts << :index if ActiveModel::Naming.uncountable?(resource_class)
    polymorphic_path(url_parts)
  end

  def top_menu_item(*args, &block)
    options = args.extract_options!
    opts = { value: args.first, block: (capture(&block) if block_given?) }.
      merge(options)

    render partial: 'shared/helpers/admin/top_menu_item', locals: opts
  end

  def admin_published_sign(*args)
    options = args.extract_options!
    render(partial: 'shared/helpers/admin/published_sign',
            locals: { options: options })
  end

  def admin_unpublished_sign(*args)
    options = args.extract_options!
    render(partial: 'shared/helpers/admin/unpublished_sign',
            locals: { options: options })
  end

  def admin_locked_sign(*args)
    options = args.extract_options!
    render(partial: 'shared/helpers/admin/locked_sign',
            locals: { options: options })
  end

  def admin_nav_published_sign(*args)
    options = args.extract_options!
    render(partial: 'shared/helpers/admin/nav_published_sign',
            locals: { options: options })
  end

  def collection_name
    I18n.t("admin.#{collection.klass.name.underscore.pluralize}.actions.index.title")
  end

  def collection_title(*args)
    options = args.extract_options!
    label = args.first || options.delete(:label) || collection_name
    title(label)
  end

  def collection_header(*args)
    options = args.extract_options!
    label = options.delete(:label) || I18n.t("admin.#{collection.klass.name.underscore.pluralize}.actions.index.header")
    with_button_new = options.delete(:button_new)
    with_button_new = true if with_button_new.blank? && with_button_new != false

    render(partial: 'shared/helpers/admin/collection_header',
            locals: { label: label, with_button_new: with_button_new })
  end

  def collection_button_new
    parent_object = parent_resource rescue nil
    record_or_hash_or_array = [:admin, parent_object, collection.klass.new].compact
    url = polymorphic_path(record_or_hash_or_array,
                            action: :new)

    render(partial: 'shared/helpers/admin/collection_button_new',
            locals: { url: url })
  end

  def object_link_new(object)
    render(partial: 'shared/helpers/admin/object_link_new',
            locals: { object: object })
  end

  def object_link_edit(object)
    parent_object = parent_resource rescue nil
    object = parent_object ? [:admin, parent_object, object] : [:admin, object]
    render(partial: 'shared/helpers/admin/object_link_edit',
            locals: { object: object })
  end

  def object_link_duplication(object)
    parent_object = parent_resource rescue nil
    object = parent_object ? [:admin, parent_object, object] : [:admin, object]
    render(partial: 'shared/helpers/admin/object_link_duplication',
            locals: { object: object })
  end

  def object_link_children(*args)
    options = args.extract_options!
    url = options.delete(:url)
    render(partial: 'shared/helpers/admin/object_link_children',
            locals: { url: url })
  end

  def resource_name(*args)
    options = args.extract_options!
    args << { primary_attribute: :name }.merge(options)
    _resource_name(*args)
  end

  def resource_nav_name(*args)
    options = args.extract_options!
    args << { primary_attribute: :nav_name }.merge(options)
    _resource_name(*args)
  end

  def _resource_name(*args)
    options = args.extract_options!
    primary_attribute = options.delete(:primary_attribute) || :name
    name = (resource.respond_to?(primary_attribute) && resource.try(primary_attribute)) ||
      (resource.respond_to?(:title) && resource.try(:title))
    if name.present?
      name
    else
      I18n.t("admin.#{resource.class.name.underscore.pluralize}.labels.actions.#{params[:action]}")
    end
  end

  def resource_title
    title(resource_name)
  end

  def resource_header(*args, &block)
    options = args.extract_options!
    text = args.first || options.delete(:text) || resource_name
    admin_page_header(text, &block)
  end

  def resource_button_value_main
    I18n.t("admin.#{resource.class.name.underscore.pluralize}.labels.actions.#{params[:action]}")
  end

  def resource_button_value_stay
    I18n.t("admin.#{resource.class.name.underscore.pluralize}.labels.actions.#{params[:action]}_stay_in_place")
  end

  def resource_button_value_cancel
    I18n.t('labels.admin.cancel')
  end

  def resource_form_object
    parent_object = parent_resource rescue nil
    if parent_object.present?
      [:admin, parent_resource, resource]
    else
      [:admin, resource]
    end
  end

  def admin_cb(object)
    content_tag :label, class: 'f-check' do
      concat(check_box_tag 'id_eq[]', object.id, false, id: "id_eq_#{object.id}")
      concat(content_tag(:span, '', class: 'f-check__box'))
    end
  end

  def batch_actions_tag(*args, &block)
    options = args.extract_options!
    with_destroy = options.delete(:with_destroy)
    with_destroy = true if with_destroy.blank? && with_destroy != false
    with_publication     = options.delete(:publication)
    with_nav_publication = options.delete(:nav_publication)

    render(partial: 'shared/helpers/admin/batch_actions_tag',
            locals: {
              block: (capture(&block) if block_given?),
              with_destroy: with_destroy,
              with_publication: with_publication,
              with_nav_publication: with_nav_publication
            })
  end

  def admin_page_header(*args, &block)
    options = args.extract_options!
    opts = { value: args.first, block: (capture(&block) if block_given?) }.
      merge(opts: options)
    render partial: 'shared/helpers/admin/page_header', locals: opts
  end

  def admin_sortable_column(column, label)
    the_col   = params[:order_by] == column.to_s
    current   = params[:direction] == 'asc' ? :asc : :desc
    direction = the_col && current == :asc ? :desc : :asc
    opts = params.merge(page: params[:page], search: params[:search], order_by: column, direction: direction)
    opts.permit!

    link_to(label, opts) + (tag(:i, class: "icon-chevron-#{current == :desc ? 'down' : 'up'}") if the_col)
  end
end
