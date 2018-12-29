RSpec.describe Adminos::IfBlankSetToNilParams, type: :model do

  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }

  describe 'if_blank_set_to_nil_params' do
    let!(:record) { build_mock_class.create(body: " ") }

    it { expect(build_mock_class).to respond_to(:if_blank_set_to_nil_params) }
    it { expect(record.body).to be nil }
  end


  def build_mock_class
    @build_mock_class ||= Class.new(ActiveRecord::Base) do
      include Adminos::IfBlankSetToNilParams

      if_blank_set_to_nil_params :body

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
