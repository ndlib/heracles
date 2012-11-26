require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
  SimpleCov.command_name "spec"
end

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

require 'rspec'
require 'rails'
require 'rspec/autorun'
require 'rspec_on_rails_matchers'
require 'rspec/given'
require 'resque_spec'

require 'factory_girl_rails'

Dir[File.expand_path("spec/support/**/*.rb", File.dirname(__FILE__))].
  each {|f| require f}

require 'rr'
require 'database_cleaner'

# # If the below is uncommented, then you will be directly hitting the Redis
# # server with all tests.
# ResqueSpec.disable_ext = true


RSpec.configure do |config|
  config.mock_with :rr
  # config.include(IntegrationServerHelper, type: :feature)
  # config.include(IntegrationServerHelper, type: :request)

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  # config.infer_base_class_for_anonymous_controllers = false
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    ResqueSpec.reset!
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    RR.verify
  end

end
