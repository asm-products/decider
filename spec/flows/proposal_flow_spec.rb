require "rails_helper"

describe ProposalFlow do
  let(:tolkein) { 'jrr.tolkein@example.com' }
  let(:martin) { 'grr.martin@example.com' }
  let(:rowling) { 'jk.rowling@example.com' }
  let(:gaiman) { 'n.gaiman@example.com' }

  describe '#create_proposal' do
    let(:flow) { ProposalFlow.new }
    let(:last_proposal) { Proposal.last }
    let(:emails) { ActionMailer::Base.deliveries }

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

    describe 'creating replies' do
      specify { expect(last_proposal.replies.map(&:stakeholder).map(&:email)).to match_array [tolkein, martin, rowling, gaiman] }
      specify { expect(last_proposal.replies.map(&:value)).to match_array [nil, nil, nil, nil] }
    end

    describe 'sending email' do
      specify { expect(emails.map(&:subject).uniq).to eq ['New proposal from J.R.R. Tolkein'] }
      specify { expect(emails.map(&:to).flatten).to match_array [tolkein, martin, rowling, gaiman] }
      specify { expect(emails[0].body).to match 'new elf world' }
    end
  end

  describe '#add_stakeholder' do
    let(:flow) { ProposalFlow.new }
    let(:proposal) { Proposal.create! description: 'new elf world', proposer: 'J.R.R. Tolkein'}

    specify do
      allow(ProposingMailer).to receive(:propose).and_call_original

      flow.add_stakeholder(martin, proposal)
      expect(ProposingMailer).to have_received(:propose).with(
            recipient: martin,
            subject: 'New proposal from J.R.R. Tolkein',
            proposal: 'new elf world',
            reply_id: Reply.last.id
          )
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
