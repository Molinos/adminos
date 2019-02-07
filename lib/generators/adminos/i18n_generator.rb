require "adminos/generators/utilities"
require "rails/generators/actions"
require "rails/generators/active_record/migration"
require "rails/generators/base"

module Adminos::Generators
  class I18nGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration
    include Utilities

    desc 'Set up I18n'
    source_root File.expand_path '../../templates/i18n', __FILE__

    class_option :devise, type: :boolean, desc: 'Add Devise views (login page, etc...) and locales?', default: false
    class_option :russian, type: :boolean, default: true
    class_option :locales, type: :array, default: %w[ru en]
    class_option :pages, type: :boolean, default: false

    def bundle_dependencies
      merge_gemfile_with('Gemfile')
      install_dependencies
    end

    def configure_application
      inject_into_file 'config/application.rb', "    config.i18n.available_locales = #{available_locales}\n", after: /Rails::Application\n/
    end

    def localize_russian
      return unless options.russian?

      inject_into_file 'config/application.rb', "    config.time_zone = 'Moscow'\n", after: /Rails::Application\n/
      inject_into_file 'config/application.rb', "    config.i18n.default_locale = :ru\n", after: /Rails::Application\n/
    end

    def localize_devise
      return unless options.devise?

      directory 'devise/views', 'app/views/devise', mode: :preserve
      copy_file 'devise/devise.ru.yml', 'config/locales/devise.ru.yml'
    end

    def inject_routes
      inject_into_file 'config/routes.rb', '  ', before: /  .*/, force: true
      inject_into_file 'config/routes.rb', "\n  scope '(:locale)', locale: /\#{I18n.available_locales.join('|')}/ do \n", before: /namespace/
      inject_into_file 'config/routes.rb', '  ', before: /namespace/, force: true
      inject_into_file 'config/routes.rb', "\n  end", after: /.*root to: 'index#index'/

      inject_into_file 'app/controllers/application_controller.rb', ', :set_locale', after: /.*before_action :reload_routes/
      inject_into_file 'app/controllers/application_controller.rb', file_content('controller.rb'), after: /.*protected\n/

      inject_into_file 'app/views/shared/admin/_footer.slim', file_content('locales.slim'), after: /.*wrapper\n/
    end

    def localize_pages
      return unless options.pages?
      file = Dir.glob('db/migrate/*.rb').grep(/\d+_create_pages.rb$/).first
      model = 'app/models/page.rb'

      %w(name nav_name body meta_description meta_title).each do |f|
        gsub_file(file, /(t.string|t.text).+:#{f}/, "t.jsonb    :#{f}")
      end

      inject_into_file model, file_content('page.rb'), before: /.*BEHAVIORS = .*/

      gsub_file(model, 'has_rich_text :content', 'I18n.available_locales.each { |locale| has_rich_text(:"content_#{locale}") }')

      comment_lines model, /validates :name/
      inject_into_file model, ', :translations_attributes', after: /.*:parent_id, :published/
      inject_into_file 'app/controllers/admin/pages_controller.rb', "            filter_by_locale: true,\n", after: /.*[:sorted],\n/
      inject_into_file 'app/controllers/application_controller.rb', "  before_action :check_page_name_locale, unless: -> { controller_path.split('/').first == 'admin' }", after: /.*before_action.*\n/
      remove_file 'app/views/admin/pages/_fields.slim'
    end

    def inject_files
      directory 'auto', '.'
    end

    def setup_tolk
      rake 'tolk:setup'
    end

    private

    def available_locales
      options.locales.reject(&:blank?).map { |s| s.strip.to_sym }.unshift(:ru).uniq
    end
  end
end
