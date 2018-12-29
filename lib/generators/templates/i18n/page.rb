  translates :name, :nav_name, :body, :meta_description, :meta_title

  accepts_nested_attributes_for :translations

  validates_with LocaleValidator
