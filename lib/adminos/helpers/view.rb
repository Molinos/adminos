module Adminos::Helpers::View
  def adminos_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: Adminos::FormBuilder)), &block)
  end

  # Helper method to render a filter form
  def adminos_filters_form_for(filters, options = {})
    return if filters.blank?

    defaults = {
      builder: Adminos::Filters::FormBuilder,
      method: :get,
      url: polymorphic_path([:admin, resource_class]),
      html: { class: 'form-inline filter-form' }
    }

    form_for resource_class.ransack(params[:q]), defaults do |f|

      filters.each do |attribute, opts|
        opts.merge!(input_html: {
          class: 'filter_row form-control'
        })

        f.filter attribute.to_sym, opts
      end

      buttons = content_tag :div, class: "buttons" do
        f.submit('Filter', class: 'btn btn-primary') +
          link_to('Clear', request.path, class: 'clear_filters_btn btn btn-secondary')
      end

      f.template.concat buttons
    end
  end

  def inside_layout(l, &block)
    content_for("#{l}_layout".to_sym, capture(&block))
    render(template: "layouts/#{l}")
  end

  def show_title
    return @title if @title.present?
    title_default
  end

  def title(*args, &block)
    return(@title = capture(&block)) if block_given?

    t = args.first
    t =
    if t.respond_to?(:seo_title) && t.seo_title.present?
      t.seo_title
    elsif t.respond_to?(:name) && t.name.present?
      t.name
    else
      t
    end

    @title = h(t)
  end

  def show_flash_alert(*args)
    options = args.extract_options!

    kind = options.delete(:kind) || :notice
    message = args.first || options.delete(:message)
    messages = { kind => message } if message.present?
    messages ||= Hash[[:error, :notice, :alert].map { |kind| [kind, flash[kind]] }]
    messages = messages.select { |key, value| value.present? }

    css_class = options.delete(:class)
    css_class = [css_class] unless css_class.is_a?(Array)
    css_class = css_class + %w(alert alert-block)

    style = options.delete(:style)

    r = ''
    messages.each do |kind, message|
      r << capture do
        render(partial: 'shared/helpers/show_flash_alert',
                locals: { message: message, kind: kind, css_class: css_class,
                  style: style, options: options })
      end
    end

    raw(r)
  end

  def alert_close
    render partial: 'shared/helpers/alert_close'
  end

  def page_header(*args, &block)
    options = args.extract_options!
    opts = { value: args.first, block: (capture(&block) if block_given?) }.
      merge(opts: options)
    render partial: 'shared/helpers/page_header', locals: opts
  end

  def breadcrumbs(*args, &block)
    options = args.extract_options!
    opts = { url: request.path,
      label: (block_given? ? capture(&block) : args.first) }.
      merge(options)

    @breadcrumbs ||= []
    @breadcrumbs << Struct::Breadcrumb.new(opts[:label], opts[:url])
  end
  alias breadcrumbs_admin breadcrumbs

  def show_breadcrumbs(*args)
    return '' if @breadcrumbs.blank?

    options = args.extract_options!

    is_admin = options.delete(:admin)
    divider = options.delete(:divider)
    divider_tag =
      if divider.present?
        divider
      elsif is_admin
        content_tag :span, '/', class: :divider
      end

    @breadcrumbs.uniq!
    @breadcrumbs.reverse! #breadcrumbs added to the beginning from the end

    render(partial: "shared/helpers/#{'admin/' if is_admin}show_breadcrumbs",
            locals: { breadcrumbs: @breadcrumbs, divider: divider_tag,
              options: options })
  end

  def optional_cls(*args)
    options = args.extract_options!
    clsses = options.map { |cls, condition| cls if condition }.compact
    [Array.wrap(args) + clsses].join(' ')
  end

  def nav_link_state(page)
    return :active if page.absolute_path == controller.request.path &&
      controller.request.request_method_symbol == :get

    if controller.request.path.starts_with?(page.absolute_path)
      :chosen
    else
      :inactive
    end
  end

  def navigation_link(object, *args)
    options  = args.extract_options!
    redirect = options.delete(:redirect)

    name = object.nav_name
    path =
      if redirect && object.default_behavior? && object.children.present?
        depth = object.descendants.published.uniq.maximum(:depth)
        object.descendants.published.where(depth: depth).first
      else
        object
      end .absolute_path
    state = path == controller.request.path ? :active : nav_link_state(object)

    stateful_link_to(
      active:   ('<li class="active"><span>' + name + '</span></li>').html_safe,
      inactive: ('<li><a href="' + path + '">' + name + '</a></li>').html_safe,
      chosen:   ('<li class="active"><a href="' + path + '">' + name + '</a></li>').html_safe,
      state:    state
    )
  end
end
