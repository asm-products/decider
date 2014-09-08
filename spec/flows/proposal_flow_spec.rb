require "rails_helper"

describe ProposalFlow do
  let(:new_proposal_attributes) { { proposer: 'J.R.R. Tolkein', description: 'new elf world' } }
  let(:existing_proposal_attributes) { { proposer: 'J.K. Rowling', description: 'more spells' } }
  let!(:existing_proposal) { Proposal.create!(existing_proposal_attributes) }
  let(:flow) { ProposalFlow.new }

  before { flow.create_proposal(new_proposal_attributes) }
  specify { expect(Proposal.last).to have_attributes(new_proposal_attributes) }
  specify { expect(flow.proposals).to match_array([new_proposal_attributes, existing_proposal_attributes]) }
end
