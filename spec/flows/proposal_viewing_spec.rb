require "rails_helper"

describe ProposalViewing do
  let(:user) { create :user, name: 'user' }
  let(:other_user) { create :user, name: 'other_user' }

  let!(:user_is_proposer) { Proposing.new(user: user).create_proposal(description: 'user_is_proposer', stakeholder_ids: []) }
  let!(:user_is_stakeholder) { Proposing.new(user: other_user).create_proposal(description: 'user_is_stakeholder', stakeholder_ids: [user.id]) }
  let!(:user_is_not_involved) { Proposing.new(user: other_user).create_proposal(description: 'user_is_not_involved', stakeholder_ids: []) }

  describe 'proposal' do
    specify { expect(ProposalViewing.new(user).proposal(user_is_proposer.id).description).to eq 'user_is_proposer' }
    specify { expect(ProposalViewing.new(user).proposal(user_is_stakeholder.id).description).to eq 'user_is_stakeholder' }
    specify { expect { ProposalViewing.new(user).proposal(user_is_not_involved.id) }.to raise_exception }
  end

  describe '#proposals' do
    it 'only returns proposals for which the user is a stakeholder' do
      expect(ProposalViewing.new(user).proposals.map(&:description)).to match_array %w[user_is_proposer user_is_stakeholder]
    end
  end
end
