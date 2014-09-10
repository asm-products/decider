require "rails_helper"

RSpec.describe 'proposing', type: :feature do
  it 'happy path' do
    visit '/proposals/new'
    fill_in 'proposal[proposer]', with: 'J.K. Rowling'
    fill_in 'proposal[proposer_email]', with: 'jk@example.com'
    fill_in 'proposal[description]', with: 'more spells'
    fill_in 'proposal[stakeholder_emails]', with: 'dadams@example.com oscard@example.com lalexander@example.com'
    click_button 'Create Proposal'

    expect(page).to have_content('J.K. Rowling proposed more spells')

    mail_sample = ActionMailer::Base.deliveries.first

    expect(mail_sample.to).to include('dadams@example.com')
    expect(mail_sample.subject).to include('J.K. Rowling')
    expect(mail_sample.body).to include('more spells')

    no_objection_path = mail_sample.body.match(/(http:.*true)/)[0]
    visit no_objection_path

    expect(page).to have_content('J.K. Rowling')
    expect(page).to have_content('more spells')
    expect(page).to have_content('dadams@example.com')

    click_link 'Proposals'

    expect(current_path).to eq(root_path)
  end
end
