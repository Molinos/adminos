require 'database_cleaner'

module Database
  def drop_table
    ActiveRecord::Base.connection.drop_table :mock_table
  end

  RSpec.configure do |config|
    # config.use_transactional_fixtures = false

    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end


