RSpec.describe Adminos::Helpers::Plugin, type: :helper do
  describe '#plugins' do
    subject(:plugins) { helper.plugins }

    before do
      class SomePlugin < Adminos::Plugins::Base
        def self.title
          'some title'
        end
      end
    end

    let(:plugin_titles) { plugins.map(&:title) }

    it 'plugin list is not empty' do
      expect(plugins).not_to be_empty
    end

    it 'return plugin title' do
      expect(plugin_titles).to include(SomePlugin.title)
    end
  end
end
