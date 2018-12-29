module Adminos::Helpers::Bootstrap
  def bs_btn(*args)
    (['btn'] + args.map { |arg| BS_BTN_CLS.include?(arg.to_s) ? "btn-#{arg}" : arg }).join(' ')
  end

  def h_bs_btn(*args)
    { class: bs_btn(*args) }
  end

  def bs_label(type, *args, &block)
    options = args.extract_options!
    bs_append_cls(options, 'label', type, BS_LABEL_CLS)
    content_tag :span, *args, options, &block
  end

  def bs_badge(type, *args, &block)
    options = args.extract_options!
    bs_append_cls(options, 'badge', type, BS_BADGE_CLS)
    content_tag :span, *args, options, &block
  end

  def bs_alert(type, *args, &block)
    options = args.extract_options!

    fade = 'fade in' if options.delete(:fade)
    bs_append_cls(options, 'alert', type, BS_ALERT_CLS, fade)

    if options[:close] || options[:close].nil?
      close = options.delete(:close) || 'x'
      close = %{<a class="close" data-dismiss="alert">#{close}</a>}
    end

    content = args.shift || capture(&block)

    content_tag :div, "#{close}#{content}".html_safe, options
  end

  def bs_icon(type, *args)
    options = args.extract_options!
    css_class = options.delete(:class)
    args << { class: "icon-#{type} #{css_class}" }.merge(options)
    content_tag(:i, nil, *args)
  end

  def bs_icon_white(type, content = nil)
    %{<i class="icon-white icon-#{type}"></i>#{content}}.html_safe
  end

  private

  def bs_append_cls(options, default, type, classes, *args)
    cls = args
    cls << default
    cls << ("#{default}-#{type}" if classes.include?(type.to_s))
    cls << options[:class]
    cls = cls.compact.join(' ')
    options[:class] = cls
  end

  BS_BTN_CLS = %w(small large mini disabled primary info success warning danger inverse)
  BS_LABEL_CLS = %w(success warning important info inverse)
  BS_ALERT_CLS = %w(error success info)
  BS_BADGE_CLS = %w(error success warning important info inverse)
end
