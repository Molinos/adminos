module VersionsHelper
  def version_item(object)
    case object.item_type
    when 'Settings'
      name = 'Настройки'
      link = :settings
    when 'User'
      name = object.item.email
    end

    link_to name || object.item.name,
      polymorphic_path([:admin, link || object.item], action: :edit) rescue ''
  end

  def version_event(object)
    if version_login? object
      'Логин'
    elsif version_registration? object
      'Регистрация'
    else
      t "admin.actions.#{object.event}"
    end
  end

  def version_login?(object)
    object.item_type == ('User') && object.changeset.include?('sign_in_count')
  end

  def version_registration?(object)
    object.item_type == ('User') && object.changeset.include?('id') &&
      object.whodunnit.blank?
  end
end
