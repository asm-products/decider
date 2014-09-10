require "rails_helper"

RSpec.describe 'proposing', type: :feature do
  def email_for(username)
    ActionMailer::Base.deliveries.find { |mail| mail.to.first == "#{username}@example.com" }
  end

  it 'happy path' do
    # create a proposal
    visit '/proposals/new'
    fill_in 'proposal[proposer]', with: 'J.K. Rowling'
    fill_in 'proposal[proposer_email]', with: 'jk@example.com'
    fill_in 'proposal[description]', with: 'more spells'
    fill_in 'proposal[stakeholder_emails]', with: 'dadams@example.com oscard@example.com lalexander@example.com'
    click_button 'Create Proposal'

    expect(page).to have_content('J.K. Rowling proposed more spells')

    # douglas adams receives an email and does not object
    adams_email = email_for('dadams')
    expect(adams_email.subject).to include('J.K. Rowling')
    expect(adams_email.body).to include('more spells')
    no_objection_path = adams_email.body.match(/(http:.*true)/)[0]
    visit no_objection_path

    # orson scott card receives an email and objects
    oscard_email = email_for('oscard')
    objection_path = oscard_email.body.match(/(http:.*false)/)[0]
    visit objection_path

    # proposal details page
    expect(page).to have_content('J.K. Rowling')
    expect(page).to have_content('more spells')
    expect(page).to have_selector('tr', text: /dadams@example.com\s*no objection/)
    expect(page).to have_selector('tr', text: /oscard@example.com\s*objection/)
    expect(page).to have_selector('tr', text: /lalexander@example.com\s*no reply/)

    click_link 'Proposals'

    expect(current_path).to eq(root_path)
  end
end
