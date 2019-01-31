require 'support/generators'

RSpec.describe Adminos::Generators::ProfileGenerator, type: :generator do

  prepare_app(folder_name: 'dummy')
  generate('adminos:profile')

  context 'controllers' do
    describe 'app/controllers/admin/profiles_controller.rb' do
      subject { file('app/controllers/admin/profiles_controller.rb') }
      it { is_expected.to exist }
    end
  end

  context 'views' do
    describe 'app/views/admin/profiles/edit.slim' do
      subject { file('app/views/admin/profiles/edit.slim') }
      it { is_expected.to exist }
    end

    describe 'app/views/shared/admin/_sidebar.slim' do
      subject { file('app/views/shared/admin/_sidebar.slim') }
      it { is_expected.to contain  /link_to edit_admin_profile_path/ }
    end
  end

  context 'config' do
    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { is_expected.to contain /resource  :profile, only: \[:edit, :update\]/ }
    end
  end
end
