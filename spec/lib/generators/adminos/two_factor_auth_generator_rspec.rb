require 'support/generators'

RSpec.describe Adminos::Generators::TwoFactorAuthGenerator, type: :generator do

  prepare_app(folder_name: 'dummy')
  generate('adminos:profile')
  generate('adminos:two_factor_auth')

  context 'controllers' do
    describe 'app/controllers/concerns/authenticates_with_two_factor.rb' do
      subject { file('app/controllers/concerns/authenticates_with_two_factor.rb') }
      it { is_expected.to exist }
    end

    describe 'app/controllers/users/sessions_controller.rb' do
      subject { file('app/controllers/users/sessions_controller.rb') }
      it { is_expected.to exist }
    end

    describe 'app/controllers/admin/profiles_controller.rb' do
      subject { file('app/controllers/admin/profiles_controller.rb') }
      it { is_expected.to contain  /def toggle_two_factor/ }
    end
  end

  context 'views' do
    describe 'app/views/admin/profiles/_2fa.slim' do
      subject { file('app/views/admin/profiles/_2fa.slim') }
      it { is_expected.to exist }
    end

    describe 'app/views/devise/sessions/two_factor.slim' do
      subject { file('app/views/devise/sessions/two_factor.slim') }
      it { is_expected.to exist }
    end

    describe 'app/views/admin/profiles/edit.slim' do
      subject { file('app/views/admin/profiles/edit.slim') }
      it { is_expected.to contain  /\= render '2fa', resource: resource/ }
    end
  end

  context 'helpers' do
    describe 'app/helpers/application_helper.rb' do
      subject { file('app/helpers/application_helper.rb') }
      it { is_expected.to contain  /def google_authenticator_qrcode/ }
    end
  end

  context 'config' do
    describe 'Gemfile' do
      subject { file('Gemfile') }
      it { is_expected.to contain /gem 'devise-two-factor'/ }
    end

    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { is_expected.to contain /resource  :profile, only: \[\] do/ }
    end
  end
end
