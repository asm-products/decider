require "rails_helper"

RSpec.describe 'login', type: :feature do
  before do
    create :user, email: 'active@example.com', name: 'Active User'
  end

  specify do
    sign_in_through_route 'active@example.com'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome, Active User'
    expect(page).to have_link 'Logout'
  end
end
