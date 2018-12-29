RSpec.describe Adminos::FlagAttrs, type: :model do

  let(:mock_class) { build_mock_class }

  before(:all) { create_table }
  after(:all) { drop_table }

  describe 'class methods' do
    describe 'flag_attrs' do
      let!(:record) { build_mock_class.create }

      it { expect(record).to respond_to(:set_published_on) }
      it { expect(record).to respond_to(:set_published_off) }

      it { expect(build_mock_class).to respond_to(:set_published_on) }
      it { expect(build_mock_class).to respond_to(:set_published_off) }

      it { expect(build_mock_class).to respond_to(:set_each_published_on) }
      it { expect(build_mock_class).to respond_to(:set_each_published_off) }

      it { expect(build_mock_class).to respond_to(:published) }
      it { expect(build_mock_class).to respond_to(:not_published) }
    end
  end

  describe 'methods' do
    describe 'instance methods' do
      describe 'define_method :"set_#{name}_on"' do
        let!(:record) { build_mock_class.create(published: false) }
        before { record.set_published_on }

        it { expect(record.published).to be true }
      end

      describe 'define_method :"set_#{name}_off"' do
        let!(:record) { build_mock_class.create(published: true) }

        before { record.set_published_off }

        it { expect(record.published).to be false }
      end
    end

    describe 'class methods' do
      describe 'define_method :"set_each_#{name}_on" ' do
        let!(:record_1) { build_mock_class.create(published: false) }
        let!(:record_2) { build_mock_class.create(published: false) }

        before { build_mock_class.set_each_published_on }

        it { expect(record_1.reload.published).to be true   }
        it { expect(record_2.reload.published).to be true   }
      end

      describe 'define_method :"set_each_#{name}_off" ' do
        let!(:record_1) { build_mock_class.create(published: false) }
        let!(:record_2) { build_mock_class.create(published: false) }

        before { build_mock_class.set_each_published_off }

        it { expect(record_1.reload.published).to be false   }
        it { expect(record_2.reload.published).to be false   }
      end

      describe 'define_method :"set_#{name}_on"' do
        let!(:record_1) { build_mock_class.create(published: false) }
        let!(:record_2) { build_mock_class.create(published: false) }

        before { build_mock_class.set_published_on }

        it { expect(record_1.reload.published).to be true   }
        it { expect(record_2.reload.published).to be true   }
      end

      describe 'define_method :"set_#{name}_off"' do
        let!(:record_1) { build_mock_class.create(published: true) }
        let!(:record_2) { build_mock_class.create(published: true) }

        before { build_mock_class.set_published_off }

        it { expect(record_1.reload.published).to be false }
        it { expect(record_2.reload.published).to be false }
      end

      describe 'scope :"#{name}"' do
        let!(:records) { Array.new(2) { build_mock_class.create(published: true) } }

        it { expect(build_mock_class.published).to contain_exactly(*records) }
      end

      describe 'scope :"not_#{name}"' do
        let!(:records) { Array.new(2) { build_mock_class.create(published: false) } }

        it { expect(build_mock_class.not_published).to contain_exactly(*records) }
      end
    end
  end

  def build_mock_class
    @build_mock_class ||= Class.new(ActiveRecord::Base) do
      include Adminos::FlagAttrs

      flag_attrs :published

      self.table_name = 'mock_table'
      reset_column_information
    end
  end

  def create_table
    ActiveRecord::Base.connection.create_table :mock_table do |t|
      t.boolean :published
    end
  end
end
