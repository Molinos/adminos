
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    I18n.locale == I18n.default_locale ? { locale: nil } : { locale: I18n.locale }
  end

  def check_page_name_locale
    redirect_to root_path if current_page.try { name.blank? }
  end
