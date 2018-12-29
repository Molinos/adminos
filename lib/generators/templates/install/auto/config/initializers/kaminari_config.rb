require 'kaminari'

Kaminari.configure do |config|
  # config.default_per_page = 25
  # config.left = 0
  # config.max_per_page = nil
  # config.outer_window = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.right = 0
  # config.window = 4
  config.left = 1
  config.right = 1
  config.window = 6
end
