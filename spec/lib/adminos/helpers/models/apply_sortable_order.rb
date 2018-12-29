RSpec.describe Adminos::ApplySortableOrder, type: :model do

  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }

  describe 'apply_sortable_order' do
    it { expect(build_mock_class).to respond_to(:apply_sortable_order) }
  end

  def build_mock_class
    @build_mock_class ||= Class.new(ActiveRecord::Base) do
      include Adminos::ApplySortableOrder

      self.table_name = 'mock_table'
      reset_column_information
    end
  end

  def create_table
    ActiveRecord::Base.connection.create_table :mock_table do |t|
      t.integer :position
    end
  end
end
