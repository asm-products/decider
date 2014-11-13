require "rails_helper"

describe Proposing do
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

      Proposing.
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

  describe 'status change' do
    let!(:flow) do
      Proposing.new(user: tolkein).tap do |flow|
        flow.create_proposal(description: 'some proposal', stakeholder_ids: [martin.id, rowling.id])
      end
    end

    before do
      allow(ProposingMailer).to receive(:status_update).and_call_original
    end

    specify { expect(flow.proposal.adopted?).to eq(false) }

    describe '#adopt' do
      before { flow.adopt }
      specify { expect(flow.proposal.adopted?).to eq(true) }

      specify do
        expect(ProposingMailer).to have_received(:status_update).with(
            user_emails: %w[grr.martin@example.com jk.rowling@example.com jrr.tolkein@example.com],
            description: 'some proposal',
            status: 'Adopted'
          )
      end
    end

    describe "#reject" do
      before { flow.reject }
      specify { expect(flow.proposal.adopted?).to eq(false) }

      specify do
        expect(ProposingMailer).to have_received(:status_update).with(
            user_emails: %w[grr.martin@example.com jk.rowling@example.com jrr.tolkein@example.com],
            description: 'some proposal',
            status: 'Rejected'
          )
      end
    end
  end
end
