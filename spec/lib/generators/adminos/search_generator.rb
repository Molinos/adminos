require 'support/generators'

RSpec.describe Adminos::Generators::SearchGenerator, type: :generator do
  prepare_app(folder_name: 'dummy')
  generate('adminos article')
  generate('adminos:search Article')


  describe "app/models/article.rb" do
    subject { file("app/models/article.rb") }

    it { is_expected.to contain /include Adminos::Searchable/ }
    it { is_expected.to contain /searchable/  }
  end

  describe "app/views/admin/articles/index.slim" do
    subject { file("app/views/admin/articles/index.slim") }

    it { is_expected.to contain "= render 'shared/admin/search_form'" }
  end
end
