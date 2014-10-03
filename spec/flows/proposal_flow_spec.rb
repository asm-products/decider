require "rails_helper"

describe ProposalFlow do
  let(:tolkein) { create :user, email: 'jrr.tolkein@example.com', name: 'J.R.R. Tolkein' }
  let(:martin) { create :user, email: 'grr.martin@example.com' }
  let(:rowling) { create :user, email: 'jk.rowling@example.com' }
  let(:gaiman) { create :user, email: 'n.gaiman@example.com' }

  describe '.for_new_proposal' do
    let(:last_proposal) { Proposal.last }
    let(:emails) { ActionMailer::Base.deliveries }

    before do
      ids = [martin, rowling, gaiman].map(&:id).map(&:to_s)
      ids << ""
      ProposalFlow.for_new_proposal(
        description: 'new elf world',
        proposer_id: tolkein,
        stakeholder_ids: ids
      )
    end

    describe 'creating a proposal record' do
      specify { expect(last_proposal.user).to eq tolkein }
      specify { expect(last_proposal.description).to eq 'new elf world' }
      specify { expect(last_proposal.users.pluck(:email)).to match_array [tolkein, martin, rowling, gaiman].map(&:email) }
    end

    describe 'creating replies' do
      specify do
        expect(last_proposal.replies.map(&:user).map(&:email)).to match_array [tolkein, martin, rowling, gaiman].map(&:email)
      end

      specify { expect(last_proposal.replies.map(&:value)).to match_array [nil, nil, nil, nil] }
    end

    describe 'sending email' do
      specify { expect(emails.map(&:subject).uniq).to eq ['New proposal from J.R.R. Tolkein'] }
      specify { expect(emails.map(&:to).flatten).to match_array [tolkein, martin, rowling, gaiman].map(&:email) }
      specify { expect(emails[0].body).to match 'new elf world' }
    end
  end

  describe '.for_proposal' do
    let(:proposal) { create :proposal, description: 'new elf world' }

    specify { expect(ProposalFlow.for_proposal(proposal.id).proposal[:description]).to eq 'new elf world' }
  end

  describe '#add_user' do
    let(:flow) { ProposalFlow.new(proposal) }
    let(:proposal) { Proposal.create! description: 'new elf world', user: tolkein }

    specify do
      allow(ProposingMailer).to receive(:propose).and_call_original

      flow.add_user(martin)
      expect(ProposingMailer).to have_received(:propose).with(
        recipient: martin.email,
        subject: 'New proposal from J.R.R. Tolkein',
        proposer: 'J.R.R. Tolkein',
        proposal: 'new elf world',
        reply_id: Reply.last.id
      )
    end
  end

  describe 'status change' do
    let(:proposal) { create :proposal_with_users }
    let(:flow) { ProposalFlow.new(proposal) }

    before do
      allow(ProposingMailer).to receive(:status_update).and_call_original
    end

    specify { expect(flow.proposal[:status]).to eq('Pending') }

    describe '#adopt' do
      before { flow.adopt }
      specify { expect(flow.proposal[:status]).to eq('Adopted') }

      specify do
        expect(ProposingMailer).to have_received(:status_update).with(
            user_emails: proposal.users.map(&:email).sort,
            description: proposal.description,
            status: 'Adopted'
          )
      end
    end

    describe "#reject" do
      before { flow.reject }
      specify { expect(flow.proposal[:status]).to eq('Rejected') }

      specify do
        expect(ProposingMailer).to have_received(:status_update).with(
            user_emails: proposal.users.map(&:email).sort,
            description: proposal.description,
            status: 'Rejected'
          )
      end
    end
  end

  describe '.all_proposals' do
    before do
      create :proposal, description: 'p1'
      create :proposal, description: 'p2'
    end

    let(:all_proposals) { ProposalFlow.all_proposals }
    specify { expect(all_proposals.map { |p| p[:description] }).to match_array %w[p1 p2] }
  end

  describe '#proposal' do
    let(:alice) { create(:user, email: 'alice@example.com') }
    let(:billy) { create(:user, email: 'billy@example.com') }
    let(:cindy) { create(:user, email: 'cindy@example.com') }

    before do
      proposal.users << alice << billy << cindy

      Reply.where(user_id: billy.id, proposal_id: proposal.id).first.update! value: true
      Reply.where(user_id: cindy.id, proposal_id: proposal.id).first.update! value: false
    end

    let(:proposal) { create :proposal, description: 'more spells', proposer: tolkein }
    let(:flow) { ProposalFlow.new(proposal) }

    specify { expect(flow.proposal[:id]).to eq proposal.id.to_s }
    specify { expect(flow.proposal[:description]).to eq 'more spells' }
    specify { expect(flow.proposal[:proposer]).to eq 'J.R.R. Tolkein' }
    specify { expect(flow.proposal[:user_emails]).to match_array %w[alice@example.com billy@example.com cindy@example.com] }
    specify { expect(flow.proposal[:status]).to eq 'Pending' }
    specify { expect(flow.proposal[:has_decision]).to eq false }

    specify do
      expect(flow.proposal[:replies]).to match_array([
            { user_email: 'alice@example.com', value: 'no reply' },
            { user_email: 'billy@example.com', value: 'no objection' },
            { user_email: 'cindy@example.com', value: 'objection' }
          ])
    end

    specify do
      flow.adopt
      expect(flow.proposal[:status]).to eq 'Adopted'
    end

    specify do
      flow.reject
      expect(flow.proposal[:status]).to eq 'Rejected'
    end
  end

  describe '#parse_emails' do
    specify { expect(ProposalFlow.send(:parse_emails, 'a@example.com b@example.com')).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(ProposalFlow.send(:parse_emails, 'a@example.com, b@example.com')).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(ProposalFlow.send(:parse_emails, "  a@example.com   , \t \nb@example.com")).to eq ['a@example.com', 'b@example.com'] }
    specify { expect(ProposalFlow.send(:parse_emails, " a@example.com ", "  b@example.com \nc@example.com")).to eq ['a@example.com', 'b@example.com', 'c@example.com'] }
  end
end
