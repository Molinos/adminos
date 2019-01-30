require 'adminos/generators/utilities'
require 'rails/generators/active_record'

module Adminos::Generators
  class InstallGenerator < ActiveRecord::Generators::Base
    include Utilities

    desc 'Creates initial adminos file and data structure'

    source_root File.expand_path '../../templates/install', __FILE__

    # ActiveRecord::Generators::Base requires a NAME parameter.
    argument :name, type: :string, default: 'random_name'

    class_option :i18n, type: :boolean, default: true, desc: 'Set up I18n'
    class_option :locales, type: :string
    class_option :is_test, type: :boolean, default: false
    class_option :ci, type: :boolean, default: true, desc: 'Set up Gitlab CI'

    def questions
      @settings = {}
      @settings[:install_devise] = ask_user('Install Devise?')
      @settings[:add_devise_views_locales] = @settings[:install_devise] || ask_user('Add Devise views (login page, etc..) and locales?')
      @settings[:add_users_to_admin_panel] = @settings[:install_devise] || ask_user('Add Devise Users to admin panel?')
      @settings[:add_authentications] = !@settings[:install_devise] || ask_user('Add Authentications for Users?')
      @settings[:install_paper_trail] = ask_user('Install PaperTrail?')
      @settings[:add_versions_to_admin_panel] = @settings[:install_paper_trail] || ask_user('Add PaperTrail versions to admin panel?')
      @settings[:add_pages] = ask_user('Create Pages model?')
      @settings[:set_default_locale_time_zone] = ask_user('Set default_locale = :ru and time_zone = "Moscow" ? in application.rb')
    end

    def bundle_dependencies
      merge_gemfile_with('Gemfile')
      install_dependencies
    end

    def auto
      directory 'auto', '.', mode: :preserve
      comment_lines 'Gemfile', /spring-watcher-listen/
    end

    def setup_ci
      return unless options.ci?

      generate 'adminos:ci'
    end

    def migrations
      migration_template 'settings_migration.rb', 'db/migrate/create_settings.rb', migration_version: migration_version
    end

    def seeds
      append_file 'db/seeds.rb', file_content('prepare_settings.rb')
    end

    def readme
      append_file 'README.md', file_content('README.md')
    end

    def templates
      template 'deploy.rb.erb', 'config/deploy.rb'
      template 'database.yml', 'config/database.yml'
      template 'database.yml', 'config/database.yml.example'
      template 'admin.slim', 'app/views/layouts/admin.slim'
      template 'application.slim.erb', 'app/views/layouts/application.slim'
      template '_sidebar.slim.erb', 'app/views/shared/admin/_sidebar.slim'
    end

    def update_gitignore
      append_file '.gitignore', file_content('.gitignore')
    end

    def update_procfile
      if file_exists?('Procfile')
        append_file('Procfile', file_content('Procfile'))
      else
        copy_file 'Procfile', 'Procfile'
      end
    end

    def install_webpacker
      run 'bundle exec rails webpacker:install'

      copy_file 'webpack/javascript/packs/admin.js', 'app/javascript/packs/admin.js'
      directory 'webpack/javascript/admin', 'app/javascript/admin'
      inject_into_file 'config/webpack/environment.js', file_content('webpack/environment.js'), before: /\nmodule.exports/
    end

    def install_active_storage
      run 'bundle exec rails active_storage:install'
    end

    def install_actiontext
      # Assets are stored in adminos-assets
      run 'bundle exec rails action_text:copy_migrations'
    end

    def run_binstubs
      run 'bundle binstubs puma'
    end

    def install_adminos_assets
      run "yarn add adminos"
    end

    def install_devise
      return unless @settings[:install_devise]
      generate 'devise:install'
      # create user
      generate 'devise', 'User roles_mask:integer --routes=false'
      remove_file 'app/models/user.rb'
      copy_file 'install_devise/user.rb', 'app/models/user.rb'
      # add ability
      copy_file 'install_devise/ability.rb', 'app/models/ability.rb'
      # some settings
      gsub_file 'config/initializers/devise.rb', /.*please-change-me-at-config-initializers-devise@example.com\'/, "  config.mailer_sender = Settings.get.email_header_from || 'admin@changeme.please' rescue nil"
      gsub_file 'config/initializers/devise.rb', /.*# config.omniauth .*/, "  config.omniauth :facebook, 'test', 'test'\n  config.omniauth :twitter, 'test', 'test'\n  config.omniauth :vkontakte, 'test', 'test'"
      inject_into_file 'config/application.rb', file_content('install_devise/application.rb'), after: /Rails::Application\n/
      # create adminos_user
      append_file 'db/seeds.rb', file_content('install_devise/prepare_users.rb')
    end

    def install_paper_trail
      return unless @settings[:install_paper_trail]
      generate 'paper_trail:install', '--with-changes'
    end

    def add_pages
      return unless @settings[:add_pages]
      migration_template 'add_pages/pages_migration.rb', 'db/migrate/create_pages.rb'
      copy_file 'add_pages/page.rb', 'app/models/page.rb'
      copy_file 'add_pages/pages_controller.rb', 'app/controllers/pages_controller.rb'
      directory 'add_pages/views/pages', 'app/views/pages', mode: :preserve
    end

    def add_authentications
      return unless @settings[:add_authentications]
      migration_template 'add_authentications/authentications_migration.rb', 'db/migrate/create_authentications.rb'
      copy_file 'add_authentications/authentication.rb', 'app/models/authentication.rb'
      copy_file 'add_authentications/authentications_controller.rb', 'app/controllers/authentications_controller.rb'
      directory 'add_authentications/views/authentications', 'app/views/authentications', mode: :preserve
    end

    def add_adminos_users
      return unless @settings[:add_users_to_admin_panel]
      # admin controller
      copy_file 'admin_panel/users/admin_users_controller.rb', 'app/controllers/admin/users_controller.rb'
      # admin views
      directory 'admin_panel/users/views/admin_users', 'app/views/admin/users', mode: :preserve
    end

    def add_adminos_versions
      return unless @settings[:add_versions_to_admin_panel]
      # admin controller
      copy_file 'admin_panel/versions/admin_versions_controller.rb', 'app/controllers/admin/versions_controller.rb'
      # admin views
      directory 'admin_panel/versions/views/admin_versions', 'app/views/admin/versions', mode: :preserve
    end

    def add_adminos_pages
      return unless @settings[:add_pages]
      # admin controller
      copy_file 'admin_panel/pages/admin_pages_controller.rb', 'app/controllers/admin/pages_controller.rb'
      # admin views
      directory 'admin_panel/pages/views/admin_pages', 'app/views/admin/pages', mode: :preserve
    end

    def copy_route_config
      routes = []
      routes << "  # ADMINOS ROUTES START"
      # devise
      if @settings[:install_devise]
        routes << "\n  devise_for :users, skip: :omniauth_callbacks"
      end
      if @settings[:add_authentications]
        routes << "\n  devise_for :users, skip: [:session, :password, :registration, :confirmation],"
        routes << "    controllers: { omniauth_callbacks: 'authentications' }"
        routes << "\n  devise_scope :user do"
        routes << "    get 'authentications/new', to: 'authentications#new'"
        routes << "    post 'authentications/link', to: 'authentications#link'"
        routes << "  end"
      end
      # adminos
      routes << "\n  namespace :admin do"
      routes << "    resources :helps, only: :index"
      routes << "    resource  :settings, only: [:edit, :update]"
      if @settings[:add_users_to_admin_panel]
        routes << "\n    resources :users, except: :show do"
        routes << "      collection { post :batch_action }"
        routes << "    end"
      end
      if @settings[:add_versions_to_admin_panel]
        routes << "\n    resources :versions, only: [:index, :show] do"
        routes << "      collection { post :batch_action }"
        routes << "    end"
      end
      if @settings[:add_pages]
        routes << "\n    resources :pages, except: :show do"
        routes << "      collection { post :batch_action }"
        routes << "      member { put :drop }"
        routes << "      member { post :duplication }"
        routes << "    end"
        routes << "\n    root to: 'pages#index', as: :root"
      end
      routes << "  end"
      routes << "\n  root to: 'index#index'"
      # pages
      if @settings[:add_pages]
        routes << file_content('routes/pages.rb')
      end
      routes << "  # ADMINOS ROUTES END\n"
      inject_into_file 'config/routes.rb', routes.join("\n"), after: /routes.draw do\n/
    end

    def modify_application_config
      inject_into_file 'config/application.rb', "    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')\n", after: /Rails::Application\n/
      inject_into_file 'config/application.rb', "    config.action_mailer.default_url_options = { host: 'molinos.ru' }\n", after: /Rails::Application\n/
      inject_into_file 'config/application.rb', "    config.generators { |g| g.test_framework :rspec }\n", after: /Rails::Application\n/
    end

    def setup_i18n
      unless i18n?
        create_file 'config/locales/ru.yml', "ru:\n"
        return
      end

      generate 'adminos:i18n', options_for_cli(
        locales: locales,
        devise: !!@settings[:add_devise_views_locales],
        russian: !!@settings[:set_default_locale_time_zone],
        pages: !!@settings[:add_pages]
      )
    end

    private

    def i18n?
      options.i18n? || locales.any?
    end

    def locales
      @locales ||= options[:locales].to_s.split(',').uniq
    end

    def ask_user(text)
      options.is_test? || yes?("#{text} (yN)")
    end
  end
end
