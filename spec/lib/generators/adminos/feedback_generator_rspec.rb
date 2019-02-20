require 'support/generators'

RSpec.describe Adminos::Generators::FeedbackGenerator, type: :generator do

  prepare_app(folder_name: 'dummy')
  generate('adminos:feedback')

  context 'controllers' do
    describe 'app/controllers/feedbacks_controller.rb' do
      subject { file('app/controllers/feedbacks_controller.rb') }
      it { is_expected.to exist }
    end

    describe 'app/controllers/admin/feedbacks_controller.rb' do
      subject { file('app/controllers/admin/feedbacks_controller.rb') }
      it { is_expected.to exist }
    end
  end

  context 'models' do
    describe 'app/models/feedback.rb' do
      subject { file('app/models/feedback.rb') }
      it { is_expected.to exist }
    end
  end

  context 'views' do
    describe 'app/views/admin/feedbacks/_fields.slim' do
      subject { file('app/views/admin/feedbacks/_fields.slim') }
      it { is_expected.to exist }
    end

    describe 'app/views/admin/feedbacks/index.slim' do
      subject { file('app/views/admin/feedbacks/index.slim') }
      it { is_expected.to exist }
    end

    describe 'app/views/shared/admin/_sidebar.slim' do
      subject { file('app/views/shared/admin/_sidebar.slim') }
      it { is_expected.to contain  /admin_feedbacks_path/ }
    end
  end

  context 'config' do
    describe 'config/routes.rb' do
      subject { file('config/routes.rb') }
      it { is_expected.to contain /resources :feedbacks, except: :show do/ }
    end
  end
end
