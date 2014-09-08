require "rails_helper"

RSpec.describe 'proposing', type: :feature do
  specify do
    visit '/proposals/new'
    fill_in 'proposal[proposer]', with: 'J.K. Rowling'
    fill_in 'proposal[description]', with: 'more spells'
    click_button 'Create Proposal'

    expect(current_path).to eq '/'
    within('.proposals') do
      expect(page).to have_content('J.K. Rowling')
      expect(page).to have_content('more spells')
    end
  end
end
