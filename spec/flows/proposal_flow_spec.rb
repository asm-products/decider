require "rails_helper"

describe ProposalFlow do
  describe '#create_proposal' do
    let(:new_proposal_attributes) do
      { proposer: 'J.R.R. Tolkein',
        proposer_email: 'jrr@example.com',
        description: 'new elf world',
        stakeholder_emails: 'dadams@example.com oscard@example.com lalexander@example.com' }
    end

    let(:flow) { ProposalFlow.new }

    before { flow.create_proposal(new_proposal_attributes) }

    specify { expect(Proposal.pluck(:proposer, :description).last).to eq ['J.R.R. Tolkein', 'new elf world'] }
    specify do
      expect(Proposal.last.stakeholders.pluck(:email)).
      to match_array %w[dadams@example.com jrr@example.com oscard@example.com lalexander@example.com]
    end
  end

  describe '#proposals' do
    let!(:proposal1) do
      Proposal.create!(proposer: 'J.K. Rowling', description: 'more spells').tap do |proposal|
        proposal.stakeholders.create! email: 'dadams@example.com'
        proposal.stakeholders.create! email: 'oscard@example.com'
      end
    end

    let!(:proposal2) do
      Proposal.create!(proposer: 'J.R.R. Tolkein', description: 'new elf world').tap do |proposal|
        proposal.stakeholders.create! email: 'lalexander@example.com'
      end
    end

    specify do
      expect(ProposalFlow.new.proposals).to match_array([
        { proposer: 'J.K. Rowling', description: 'more spells', stakeholder_emails: ['dadams@example.com', 'oscard@example.com'] },
        { proposer: 'J.R.R. Tolkein', description: 'new elf world', stakeholder_emails: ['lalexander@example.com'] }
      ])
    end
  end

  describe '#parse_emails' do
    let(:flow) { ProposalFlow.new }
    specify { expect(flow.send(:parse_emails, 'a@example.com b@example.com')).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(flow.send(:parse_emails, 'a@example.com, b@example.com')).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(flow.send(:parse_emails, "  a@example.com   , \t \nb@example.com")).to eq ['a@example.com', 'b@example.com'] }
  end
end
