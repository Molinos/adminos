  extend Mobility

  translates :name, :nav_name, :body, :meta_description, :meta_title, locale_accessors: true, ransack: true

  validates_with LocaleValidator
