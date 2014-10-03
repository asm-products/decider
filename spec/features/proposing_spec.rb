require "rails_helper"

RSpec.describe 'proposing', type: :feature do
  def email_for(username)
    ActionMailer::Base.deliveries.find { |mail| mail.to.first == "#{username}@example.com" }
  end

  def proposal_details_page
    %r|/proposals/\d+|
  end

  def create_proposal(description)
    visit '/proposals/new'
    fill_in 'proposal[proposer]', with: 'Paul Proposer'
    fill_in 'proposal[proposer_email]', with: 'paul@example.com'
    fill_in 'proposal[description]', with: description
    check "alice"
    check "billy"
    check "cindy"

    within '.stakeholders' do
      expect(all('label').map(&:text)).to match_array %w[alice billy cindy]
    end

    click_button 'Create Proposal'
  end

  def reply_link(recipient, value)
    email_for(recipient).body.match(/(http:.*#{value})/)[0]
  end

  def no_objection_link(recipient)
    reply_link(recipient, true)
  end

  def objection_link(recipient)
    reply_link(recipient, false)
  end

  before do
    create :user, email: 'paul@example.com', name: 'Paul Proposer'
    %w[alice@example.com billy@example.com cindy@example.com].each do |email|
      create :user, email: email, name: email.split('@').first
    end
  end

  specify 'adopted proposal flow' do
    sign_in_through_route 'paul@example.com'
    create_proposal 'perfect proposal'

    expect(current_path).to eq root_path
    expect(page).to have_content('Paul Proposer proposed perfect proposal')

    expect(ActionMailer::Base.deliveries.count).to eq 4
    expect(ActionMailer::Base.deliveries.map(&:subject).uniq).to eq ['New proposal from Paul Proposer']

    visit no_objection_link('alice')
    visit objection_link('billy')

    expect(current_path).to match proposal_details_page
    expect(page).to have_content('Paul Proposer')
    expect(page).to have_content('perfect proposal')
    expect(page).to have_selector('tr', text: /alice@example.com\s*no objection/)
    expect(page).to have_selector('tr', text: /billy@example.com\s*objection/)
    expect(page).to have_selector('tr', text: /cindy@example.com\s*no reply/)

    click_button 'Adopt this proposal'
    expect(page).to have_content('Proposal Adopted')
    expect(page).to_not have_selector('button', text: 'Adopt this proposal')
    expect(page).to_not have_selector('button', text: 'Reject this proposal')

    click_link 'Proposals'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('perfect proposal - Adopted')
  end

  specify 'rejected proposal flow' do
    sign_in_through_route 'paul@example.com'

    create_proposal 'putrid proposal'
    expect(page).to have_content('Paul Proposer proposed putrid proposal')

    visit objection_link('alice')
    visit objection_link('billy')

    ActionMailer::Base.deliveries.clear

    click_button 'Reject this proposal'
    expect(page).to have_content('Proposal Rejected')
    expect(page).to_not have_selector('button', text: 'Adopt this proposal')
    expect(page).to_not have_selector('button', text: 'Reject this proposal')

    click_link 'Proposals'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('putrid proposal - Rejected')

    alice_email = email_for('alice')
    expect(alice_email.subject).to eq('Proposal Rejected: putrid proposal')
  end
end
