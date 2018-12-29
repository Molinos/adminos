class Post < ActiveRecord::Base
  include Adminos::FlagAttrs

  # attr_accessor :published

  # flag_attrs :published

end
