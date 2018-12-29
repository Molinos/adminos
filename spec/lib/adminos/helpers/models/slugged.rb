require 'friendly_id'

RSpec.describe Adminos::Slugged, type: :model do

  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }

  describe 'if_blank_set_to_nil_params' do
    let!(:record) { build_mock_class.create(name: "test/new/string") }

    it { expect(build_mock_class).to respond_to(:slugged) }
    it { expect(record.slug).to eq 'test-new-string' }
  end

  def build_mock_class
    @build_mock_class ||= Class.new(ActiveRecord::Base) do
      include Adminos::Slugged

      slugged :name

      self.table_name = 'mock_table'
      reset_column_information

      def self.name
        'MockTable'
      end
    end
  end

  def create_table
    build_mock_class.reset_column_information

    ActiveRecord::Base.connection.create_table :mock_table do |t|
      t.text :name
      t.text :slug
    end
  end
end
