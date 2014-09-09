require "rails_helper"

describe ProposalFlow do
  let(:tolkein) { 'jrr.tolkein@example.com' }
  let(:martin) { 'grr.martin@example.com' }
  let(:rowling) { 'jk.rowling@example.com' }
  let(:gaiman) { 'n.gaiman@example.com' }

  describe '#create_proposal' do
    let(:flow) { ProposalFlow.new }
    let(:last_proposal) { Proposal.last }
    let(:last_email) { ActionMailer::Base.deliveries.last }

    before do
      flow.create_proposal(
        proposer: 'J.R.R. Tolkein',
        proposer_email: tolkein,
        description: 'new elf world',
        stakeholder_emails: [martin, rowling, gaiman].join(' ')
      )
    end

    describe 'creating a proposal record' do
      specify { expect(last_proposal.proposer).to eq 'J.R.R. Tolkein' }
      specify { expect(last_proposal.description).to eq 'new elf world' }
      specify { expect(last_proposal.stakeholders.pluck(:email)).to match_array [tolkein, martin, rowling, gaiman] }
    end

    describe 'sending email' do
      specify { expect(last_email.subject).to eq 'New proposal from J.R.R. Tolkein' }
      specify { expect(last_email.to).to match_array [tolkein, martin, rowling, gaiman] }
      specify { expect(last_email.body).to match 'new elf world' }
    end
  end

  describe '#proposals' do
    let!(:proposal1) do
      Proposal.create!(proposer: 'J.K. Rowling', description: 'more spells').tap do |proposal|
        proposal.stakeholders.create! email: martin
        proposal.stakeholders.create! email: rowling
      end
    end

    let!(:proposal2) do
      Proposal.create!(proposer: 'J.R.R. Tolkein', description: 'new elf world').tap do |proposal|
        proposal.stakeholders.create! email: gaiman
      end
    end

    specify do
      expect(ProposalFlow.new.proposals).to match_array([
        { proposer: 'J.K. Rowling', description: 'more spells', stakeholder_emails: [martin, rowling] },
        { proposer: 'J.R.R. Tolkein', description: 'new elf world', stakeholder_emails: [gaiman] }
      ])
    end
  end

  describe '#parse_emails' do
    let(:flow) { ProposalFlow.new }
    specify { expect(flow.send(:parse_emails, 'a@example.com b@example.com')).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(flow.send(:parse_emails, 'a@example.com, b@example.com')).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(flow.send(:parse_emails, "  a@example.com   , \t \nb@example.com")).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(flow.send(:parse_emails, " a@example.com ", "  b@example.com \nc@example.com")).to eq ['a@example.com', 'b@example.com', 'c@example.com'] }
  end
end
