require "rails_helper"

describe ProposalPresenter do
  let(:alice) { create(:user, email: 'alice@example.com') }
  let(:billy) { create(:user, email: 'billy@example.com') }
  let(:cindy) { create(:user, email: 'cindy@example.com') }
  let(:tolkein) { create :user, email: 'jrr.tolkein@example.com', name: 'J.R.R. Tolkein' }

  let(:proposal) { create :proposal, description: 'more spells', proposer: tolkein }
  let(:presenter) { ProposalPresenter.new(proposal) }

  before do
    proposal.users << alice << billy << cindy

    Reply.where(user_id: billy.id, proposal_id: proposal.id).first.update! value: true
    Reply.where(user_id: cindy.id, proposal_id: proposal.id).first.update! value: false
  end

  specify { expect(presenter.id).to eq proposal.id.to_s }
  specify { expect(presenter.description).to eq 'more spells' }
  specify { expect(presenter.proposer).to eq 'J.R.R. Tolkein' }
  specify { expect(presenter.user_emails).to match_array %w[alice@example.com billy@example.com cindy@example.com] }
  specify { expect(presenter.status).to eq 'Pending' }
  specify { expect(presenter.has_decision?).to eq false }

  specify do
    expect(presenter.replies.map {|r| [ r.user_email, r.value ] }).to match_array([
      [ 'alice@example.com', 'no reply' ],
      [ 'billy@example.com', 'no objection' ],
      [ 'cindy@example.com', 'objection' ],
    ])
  end

  specify do
    proposal.update! adopted: true
    expect(presenter.status).to eq 'Adopted'
  end

  specify do
    proposal.update! adopted: false
    expect(presenter.status).to eq 'Rejected'
  end
end
