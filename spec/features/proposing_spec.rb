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

  def proposal_status(proposal_text)
    page.find('.proposal', text: proposal_text).find('.label').text
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

    expect(current_path).to eq proposals_path
    expect(page).to have_content(/perfect proposal\s*Pending\s*Proposed by Paul Proposer/)

    expect(ActionMailer::Base.deliveries.count).to eq 4
    expect(ActionMailer::Base.deliveries.map(&:subject).uniq).to eq ['New proposal from Paul Proposer']

    logout
    visit no_objection_link('alice')
    sign_in_through_route 'alice@example.com'

    logout
    visit objection_link('billy')
    sign_in_through_route 'billy@example.com'

    expect(current_path).to match proposal_details_page
    expect(page).to have_content('Paul Proposer')
    expect(page).to have_content('perfect proposal')
    expect(page).to have_selector('tr', text: /alice@example.com\s*no objection/)
    expect(page).to have_selector('tr', text: /billy@example.com\s*objection/)
    expect(page).to have_selector('tr', text: /cindy@example.com\s*no reply/)
    expect(page).to_not have_button('Adopt this proposal')

    proposal_path = current_path
    logout
    sign_in_through_route 'paul@example.com'
    visit proposal_path

    click_button 'Adopt this proposal'
    expect(page).to have_content('Proposal Adopted')
    expect(page).to_not have_selector('button', text: 'Adopt this proposal')
    expect(page).to_not have_selector('button', text: 'Reject this proposal')

    click_link 'Proposals'
    expect(current_path).to eq(proposals_path)
    expect(proposal_status('perfect proposal')).to eq 'Adopted'
  end

  specify 'rejected proposal flow' do
    sign_in_through_route 'paul@example.com'

    create_proposal 'putrid proposal'
    expect(page).to have_content(/putrid proposal\s*Pending\s*Proposed by Paul Proposer/)

    logout
    visit objection_link('alice')
    sign_in_through_route('alice@example.com')

    logout
    visit objection_link('billy')
    sign_in_through_route('billy@example.com')

    ActionMailer::Base.deliveries.clear

    proposal_path = current_path
    logout
    sign_in_through_route 'paul@example.com'
    visit proposal_path

    click_button 'Reject this proposal'
    expect(page).to have_content('Proposal Rejected')
    expect(page).to_not have_selector('button', text: 'Adopt this proposal')
    expect(page).to_not have_selector('button', text: 'Reject this proposal')

    click_link 'Proposals'
    expect(current_path).to eq(proposals_path)
    expect(proposal_status('putrid proposal')).to eq 'Rejected'

    alice_email = email_for('alice')
    expect(alice_email.subject).to eq('Proposal Rejected: putrid proposal')
  end
end
