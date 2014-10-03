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
  unless current_path == new_user_path
    visit '/'
    click_link "Sign Up"
  end
  fill_in 'user[email]', with: email
  fill_in 'user[name]', with: name
  fill_in 'user[password]', with: 'password'
  click_button 'Sign Up'
end

def sign_in_through_route(email)
  unless current_path == login_path
    visit '/'
    click_link "Sign In"
  end
  fill_in "Email", with: email
  fill_in "Password", with: "password"
  click_button "Sign In"
end

def logout
  click_link 'Logout'
end
