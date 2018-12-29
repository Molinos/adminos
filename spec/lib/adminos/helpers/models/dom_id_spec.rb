RSpec.describe Adminos::DomId, type: :model do

  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }

  describe 'with_dom_id' do
    let!(:record) { build_mock_class.create }

    it { expect(build_mock_class).to respond_to(:with_dom_id) }
    it { expect(record).to respond_to(:dom_id) }
  end

  describe 'dom_id' do
    let!(:record) { build_mock_class.create }

    it { expect(record.dom_id).to eq "mock_table_#{record.id}" }
  end

  def build_mock_class
    @build_mock_class ||= Class.new(ActiveRecord::Base) do
      include Adminos::DomId

      with_dom_id :id

      self.table_name = 'mock_table'
      reset_column_information

      def self.name
        'MockTable'
      end
    end
  end

  def create_table
    ActiveRecord::Base.connection.create_table :mock_table do |t|
      t.text :body
    end
  end
end
