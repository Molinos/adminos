require 'support/generators'

RSpec.describe Adminos::Generators::AdminosGenerator, type: :generator do

  context 'default locales' do
    prepare_app(folder_name: 'dummy')

    %w(default section sortable table).each do |type|
      context "the generated files for type: #{type}" do
        name = "event_#{type}"
        let(:command) { "adminos #{name.classify} --type #{type} --quiet" }

        before { generate(command) }

        describe "app/models/#{name}.rb" do
          subject { file("app/models/#{name}.rb") }
          it { is_expected.to exist }
        end

        describe "app/controllers/admin/#{name.pluralize}_controller.rb" do
          subject { file("app/controllers/admin/#{name.pluralize}_controller.rb") }
          it { is_expected.to exist }
        end

        describe "config/routes.rb" do
          subject { file("config/routes.rb") }
          it { is_expected.to contain  /resources :#{name.pluralize}, except: :show/ }
        end

        describe "app/views/shared/admin/_sidebar.slim" do
          subject { file("app/views/shared/admin/_sidebar.slim") }
          it { is_expected.to contain /\= top_menu_item active: 'admin\/#{name.pluralize}\#'/  }
        end

        describe "config/locales/adminos.ru.yml" do
          subject { file("config/locales/adminos.ru.yml") }
          it { is_expected.to contain /#{name.pluralize}:/ }
        end

        describe "app/views/admin/#{name.pluralize}/_fields.slim" do
          subject { file("app/views/admin/#{name.pluralize}/_fields.slim") }

          it { is_expected.to exist }
        end

        describe "app/views/admin/#{name.pluralize}/index.slim" do
          subject { file("app/views/admin/#{name.pluralize}/index.slim") }

          it { is_expected.to exist }
        end
      end
    end
  end

  context 'with ru, :en locales' do
    prepare_app(folder_name: 'dummy_en', locales: 'en,ru')

    %w(default).each do |type|
      context "the generated files for type: #{type}" do
        name = "event_#{type}"
        let(:command) { "adminos #{name.classify} --type #{type} --locale --force --quiet" }

        before { generate(command) }

        describe "app/views/admin/#{name.pluralize}/_locale_fields.slim" do
          subject { file("app/views/admin/#{name.pluralize}/_locale_fields.slim") }

          it { is_expected.to exist }
        end

        describe "app/views/admin/#{name.pluralize}/_general_fields.slim" do
          subject { file("app/views/admin/#{name.pluralize}/_general_fields.slim") }

          it { is_expected.to exist }
        end

        describe "app/models/#{name}.rb" do
          subject { file("app/models/#{name}.rb") }

          it { is_expected.to exist }
        end

        describe "config/routes.rb" do
          subject { file("config/routes.rb") }
          it { is_expected.to contain  /resources :#{name.pluralize}, except: :show/ }
        end


        describe "config/locales/adminos.ru.yml" do
          subject { file("config/locales/adminos.ru.yml") }
          it { is_expected.to contain /#{name.pluralize}:/ }
        end

        describe "app/controllers/admin/#{name.pluralize}_controller.rb" do
          subject { file("app/controllers/admin/#{name.pluralize}_controller.rb") }
          it { is_expected.to exist }
        end

        describe "app/views/admin/#{name.pluralize}" do
          subject { file("app/views/admin/#{name.pluralize}") }
          it { is_expected.to exist }
        end
      end
    end
  end
end
