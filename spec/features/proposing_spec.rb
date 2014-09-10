require "rails_helper"

RSpec.describe 'proposing', type: :feature do
  describe 'happy path' do
    visit '/proposals/new'
    fill_in 'proposal[proposer]', with: 'J.K. Rowling'
    fill_in 'proposal[proposer_email]', with: 'jk@example.com'
    fill_in 'proposal[description]', with: 'more spells'
    fill_in 'proposal[stakeholder_emails]', with: 'dadams@example.com oscard@example.com lalexander@example.com'
    click_button 'Create Proposal'

    expect(current_path).to eq '/'
    within('.proposals') do
      expect(page).to have_content('J.K. Rowling')
      expect(page).to have_content('more spells')
      expect(page).to have_content('dadams@example.com')
      expect(page).to have_content('jk@example.com')
      expect(page).to have_content('oscard@example.com')
      expect(page).to have_content('lalexander@example.com')
    end

    mail_sample = ActionMailer::Base.deliveries.first

    expect(mail_sample.to).to include('dadams@example.com')
    expect(mail_sample.subject).to include('J.K. Rowling')
    expect(mail_sample.body).to include('more spells')
  end
end
