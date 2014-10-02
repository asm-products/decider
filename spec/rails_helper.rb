ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.before(:each) { ActionMailer::Base.deliveries.clear }
  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def sign_up_through_route(email, name)
  visit '/users/new'
  fill_in 'user[email]', with: email
  fill_in 'user[name]', with: name
  fill_in 'user[password]', with: 'password'
  click_button 'Sign Up'
end
