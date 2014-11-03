require "rails_helper"

describe ProposalFlow do
  let(:tolkein) { create :user, email: 'jrr.tolkein@example.com', name: 'J.R.R. Tolkein' }
  let(:martin) { create :user, email: 'grr.martin@example.com' }
  let(:rowling) { create :user, email: 'jk.rowling@example.com' }
  let(:gaiman) { create :user, email: 'n.gaiman@example.com' }

  describe '#create_proposal' do
    let(:last_proposal) { Proposal.last }
    let(:emails) { ActionMailer::Base.deliveries }

    before do
      ids = [martin, rowling, gaiman].map(&:id).map(&:to_s)
      ids << ""

      ProposalFlow.
        new(user: tolkein).
        create_proposal(
          description: 'new elf world',
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

  describe 'proposal' do
    let(:proposal) { create :proposal, description: 'new elf world' }

    specify { expect(ProposalFlow.new(user: tolkein, proposal_id: proposal.id).proposal.description).to eq 'new elf world' }
  end

  describe '#add_user' do
    let(:flow) { ProposalFlow.new(user: tolkein, proposal_id: proposal.id) }
    let(:proposal) { Proposal.create! description: 'new elf world', user: tolkein }

    specify do
      allow(ProposingMailer).to receive(:propose).and_call_original

      flow.add_stakeholder(martin)
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
    let(:flow) { ProposalFlow.new(user: tolkein, proposal_id: proposal.id) }

    before do
      allow(ProposingMailer).to receive(:status_update).and_call_original
    end

    specify { expect(flow.proposal.status).to eq('Pending') }

    describe '#adopt' do
      before { flow.adopt }
      specify { expect(flow.proposal.status).to eq('Adopted') }

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
      specify { expect(flow.proposal.status).to eq('Rejected') }

      specify do
        expect(ProposingMailer).to have_received(:status_update).with(
            user_emails: proposal.users.map(&:email).sort,
            description: proposal.description,
            status: 'Rejected'
          )
      end
    end
  end

  describe '#proposals' do
    let(:user) { create :user }

    before do
      create :proposal, description: 'p1'
      create :proposal, description: 'p2'
    end

    let(:proposals) { ProposalFlow.new(user: user).proposals }
    specify { expect(proposals.map { |p| p.description }).to match_array %w[p1 p2] }
  end
end
