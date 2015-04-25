require "rails_helper"

RSpec.describe 'registering', type: :feature do
  specify do
    sign_up_through_route 'email@example.com', 'Alice Aardvark'

    expect(current_path).to eq proposals_path
    expect(page).to have_content 'Welcome, Alice Aardvark'
  end
end
