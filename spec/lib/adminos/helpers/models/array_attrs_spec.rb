RSpec.describe Adminos::ArrayAttrs, type: :model do

  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }


  describe 'array_attrs' do
    let!(:record) { build_mock_class.create }

    it { expect(record).to respond_to(:body_to_a) }
  end

  describe 'instace methods' do
    let!(:record) { build_mock_class.create(body: "line1\nLine2\nLine3") }

    it { expect(record.body_to_a).to match_array(['line1', 'Line2', 'Line3'])}
  end


  def build_mock_class
    @build_mock_class ||= Class.new(ActiveRecord::Base) do
      include Adminos::ArrayAttrs

      array_attrs :body

      self.table_name = 'mock_table'
      reset_column_information
    end
  end

  def create_table
    ActiveRecord::Base.connection.create_table :mock_table do |t|
      t.text :body
    end
  end
end
