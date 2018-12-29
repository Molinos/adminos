require 'support/generators'

RSpec.describe Adminos::Generators::InstallGenerator, type: :generator do


  context 'default' do
    prepare_app(folder_name: 'dummy')

    context 'models' do
      describe 'app/models/user.rb' do
        subject { file('app/models/user.rb') }
        it { is_expected.to exist }
      end

      describe 'app/models/page.rb' do
        subject { file('app/models/page.rb') }
        it { is_expected.to exist }
      end

      describe 'app/models/ability.rb' do
        subject { file('app/models/ability.rb') }
        it { is_expected.to exist }
      end

      describe 'app/models/settings.rb' do
        subject { file('app/models/settings.rb') }
        it { is_expected.to exist }
      end

      describe 'app/models/authentication.rb' do
        subject { file('app/models/authentication.rb') }
        it { is_expected.to exist }
      end
    end

    context 'controllers' do
      describe 'app/controllers/pages_controller.rb' do
        subject { file('app/controllers/pages_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/application_controller.rb' do
        subject { file('app/controllers/application_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/authentications_controller.rb' do
        subject { file('app/controllers/authentications_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/base_controller.rb' do
        subject { file('app/controllers/admin/base_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/helps_controller.rb' do
        subject { file('app/controllers/admin/helps_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/pages_controller.rb' do
        subject { file('app/controllers/admin/pages_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/settings_controller.rb' do
        subject { file('app/controllers/admin/settings_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/users_controller.rb' do
        subject { file('app/controllers/admin/users_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/versions_controller.rb' do
        subject { file('app/controllers/admin/versions_controller.rb') }
        it { is_expected.to exist }
      end

      describe 'app/controllers/admin/users_controller.rb' do
        subject { file('app/controllers/admin/users_controller.rb') }
        it { is_expected.to exist }
      end
    end

    context 'views' do
      describe 'app/views/admin' do
        subject { file('app/views/admin') }
        it { is_expected.to exist }
      end

      describe 'app/views/admin/base' do
        subject { file('app/views/admin/base') }
        it { is_expected.to exist }
      end

      describe 'app/views/admin/helps' do
        subject { file('app/views/admin/helps') }
        it { is_expected.to exist }
      end

      describe 'app/views/admin/pages' do
        subject { file('app/views/admin/pages') }
        it { is_expected.to exist }
      end

      describe 'app/views/admin/settings' do
        subject { file('app/views/admin/settings') }
        it { is_expected.to exist }
      end

      describe 'app/views/admin/versions' do
        subject { file('app/views/admin/versions') }
        it { is_expected.to exist }
      end

      describe 'app/views/admin/users' do
        subject { file('app/views/admin/users') }
        it { is_expected.to exist }
      end

      describe 'app/views/authentications' do
        subject { file('app/views/authentications') }
        it { is_expected.to exist }
      end

      describe 'app/views/devise' do
        subject { file('app/views/devise') }
        it { is_expected.to exist }
      end

      describe 'app/views/kaminari' do
        subject { file('app/views/kaminari') }
        it { is_expected.to exist }
      end

      describe 'app/views/layouts' do
        subject { file('app/views/layouts') }
        it { is_expected.to exist }
      end

      describe 'app/views/shared' do
        subject { file('app/views/shared') }
        it { is_expected.to exist }
      end

      describe 'app/views/pages/show.slim' do
        subject { file('app/views/pages/show.slim') }
        it { is_expected.to exist }
      end
    end

    context 'config' do
      describe '.ruby-version' do
        subject { file('.ruby-version') }
        it { is_expected.to contain /#{RUBY_VERSION}/  }
      end

      describe 'config/initializers/simple_form.rb' do
        subject { file('config/initializers/simple_form.rb') }
        it { is_expected.to exist }
      end

      describe 'config/initializers/kaminari_config.rb' do
        subject { file( 'config/initializers/kaminari_config.rb') }
        it { is_expected.to exist }
      end

      describe 'config/locales/devise.ru.yml' do
        subject { file( 'config/locales/devise.ru.yml') }
        it { is_expected.to exist }
      end

      describe 'config/locales/adminos.ru.yml' do
        subject { file( 'config/locales/adminos.ru.yml') }
        it { is_expected.to exist }
      end

      describe 'config/routes.rb' do
        subject { file( 'config/routes.rb') }
        it { is_expected.to exist }
      end

      describe 'config/application.rb' do
        subject { file( 'config/application.rb') }
        it { is_expected.to contain  /config.time_zone = 'Moscow'/  }
        it { is_expected.to contain /config.i18n.default_locale = :ru/  }
      end
    end

    context 'mailers' do
      describe 'app/mailers/notifier.rb' do
        subject { file( 'app/mailers/notifier.rb') }
        it { is_expected.to exist }
      end
    end

    context 'assets' do
      describe 'app/assets/stylesheets/admin/application.scss' do
        subject { file('app/assets/stylesheets/admin/application.scss') }
        it { is_expected.to exist }
      end
      describe 'app/assets/javascripts/admin/application.js' do
        subject { file('app/assets/javascripts/admin/application.js') }
        it { is_expected.to exist }
      end
    end

    context 'deploy' do
      describe 'config/deploy.rb' do
        subject { file('config/deploy.rb') }
        it { is_expected.to exist }
      end

      describe 'config/deploy/staging.rb' do
        subject { file('config/deploy/staging.rb') }
        it { is_expected.to exist }
      end
    end

    context 'general' do
      describe 'public/404.html' do
        subject { file('public/404.html') }
        it { is_expected.to exist }
      end

      describe 'public/500.html' do
        subject { file('public/500.html') }
        it { is_expected.to exist }
      end

      describe 'Capfile' do
        subject { file('Capfile') }
        it { is_expected.to exist }
      end

      describe 'Gemfile' do
        subject { file('Gemfile') }
        it { is_expected.to exist }
      end
    end
  end

  context 'with locales en,nl' do
    prepare_app(folder_name: 'dummy_en', locales: 'en,nl')

    context 'models' do
      describe 'app/models/page.rb' do
        subject { file('app/models/page.rb') }
        it { is_expected.to contain /translates :name, .*/  }
        it { is_expected.to contain  /accepts_nested_attributes_for :translations/  }
      end
    end

    context 'controllers' do
      describe 'app/controllers/admin/pages_controller.rb' do
        subject { file('app/controllers/admin/pages_controller.rb') }
        it { is_expected.to contain /filter_by_locale: true/  }
      end

      describe 'app/controllers/application_controller.rb' do
        subject { file('app/controllers/application_controller.rb') }
        it { is_expected.to contain /, :set_locale/  }
        it { is_expected.to contain /def default_url_options/  }
      end
    end

    context 'views' do
      describe 'app/views/admin/base/_fields.slim' do
        subject { file('app/views/admin/base/_fields.slim') }
        it { is_expected.to exist  }
      end

      describe 'app/views/admin/base/_pills.slim' do
        subject { file('app/views/admin/base/_pills.slim') }
        it { is_expected.to exist  }
      end

      describe 'app/views/admin/pages/_general_fields.slim' do
        subject { file('app/views/admin/pages/_general_fields.slim') }
        it { is_expected.to exist  }
      end

      describe 'app/views/admin/pages/_locale_fields.slim' do
        subject { file('app/views/admin/pages/_locale_fields.slim') }
        it { is_expected.to exist }
      end

      describe 'app/views/shared/admin/_sidebar.slim' do
        subject { file('app/views/shared/admin/_sidebar.slim') }
        it { is_expected.to contain  /I18n.available_locales.each do |locale|/ }
      end
    end

    context 'config' do
      describe 'config/initializers/globalize_fields.rb' do
        subject { file('config/initializers/globalize_fields.rb') }
        it { is_expected.to exist }
      end

      describe 'config/routes.rb' do
        subject { file('config/routes.rb') }
        it { is_expected.to contain /scope '\(:locale\)'/ }
      end

      describe 'config/application.rb' do
        subject { file('config/application.rb') }
        it { is_expected.to contain /config.i18n.available_locales = \[:ru, :en, :nl\]/ }
      end
    end

    context 'Gemfile' do
      describe 'Gemfile' do
        subject { file('Gemfile') }
        it { is_expected.to contain  /gem 'globalize'/ }
      end
    end
  end
end

