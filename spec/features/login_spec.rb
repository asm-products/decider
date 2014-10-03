require "rails_helper"

RSpec.describe 'login', type: :feature do
  before do
    create :user, email: 'active@example.com', name: 'Active User'
  end

  specify do
    sign_in_through_route 'active@example.com'

    expect(current_path).to eq proposals_path
    expect(page).to have_content 'Welcome, Active User'
    click_link "Logout"
    expect(page).to have_content "Sign In"
  end
end
