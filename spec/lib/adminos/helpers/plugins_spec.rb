RSpec.describe Adminos::Helpers::Plugin, type: :helper do
  describe '#plugins_name' do
    let(:plugin_names_list) { helper.plugins_name }

    before do
      class SomePlugin < Adminos::Plugins::Base
        def self.name
          'some name'
        end
      end
    end

    it 'list plugin names in not empty' do
      expect(plugin_names_list).not_to be_empty
    end

    it 'return list plugin names' do
      expect(plugin_names_list).to include(SomePlugin.name)
    end
  end
end
