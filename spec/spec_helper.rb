require 'factory_bot_rails'
require 'simplecov'
require 'shoulda/matchers'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  enable_coverage :branch
end

require 'capybara/rspec'
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'database_cleaner/active_record'

RSpec.configure do |config|
  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Expectations
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Mocks
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Shared metadata behavior
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Shoulda Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.order = :random
  Kernel.srand config.seed
end
