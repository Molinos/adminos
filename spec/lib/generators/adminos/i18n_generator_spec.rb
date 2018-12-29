require 'support/generators'

RSpec.describe Adminos::Generators::I18nGenerator, type: :generator do
  prepare_app(folder_name: 'dummy')

  context 'when using defaults' do
    let(:arguments) { [] }

    it_behaves_like 'everything works'

    describe 'the generated files' do
      before { run_generator(arguments) }

      it_behaves_like 'Gemfile'
      it_behaves_like 'config/application.rb'
    end
  end

  context 'when all included' do
    let(:arguments) { %w[--devise --pages --russian] }

    it_behaves_like 'everything works'

    describe 'the generated files' do
      before { run_generator(arguments) }

      it_behaves_like 'Gemfile'
      it_behaves_like 'config/application.rb'
    end
  end
end
