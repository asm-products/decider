require 'rails_helper'

describe RepliesController , :type => :controller do
  let(:user) { create :user }
  let(:reply) { create :reply, user: user }

  def do_get(value: 'true')
    get :show, id: reply.to_param, value: value
  end

  context 'with a logged in user' do
    before { login_user user }

    specify do
      expect { do_get(value: 'true') }.to change { reply.reload.value }.to(true)
    end

    specify do
      expect { do_get(value: 'false') }.to change { reply.reload.value }.to(false)
    end

    specify do
      do_get
      expect(response).to redirect_to(proposal_path(reply.proposal.id))
    end
  end
end
