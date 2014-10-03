require 'rails_helper'

describe ReplyFlow do
  describe '#reply' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:reply) { create :reply, user: user }

    it "allows the reply's user to reply" do
      flow = ReplyFlow.new(user: user, reply_id: reply.id)

      expect {
        flow.reply(true)
      }.to change { reply.reload.value }.from(nil).to(true)
    end

    it "does not allow another user to reply" do
      expect { ReplyFlow.new(user: other_user, reply_id: reply.id) }.to raise_exception ActiveRecord::RecordNotFound
    end
  end
end
