require 'rails_helper'

describe RepliesController do
  let(:reply) { Reply.create }

  def do_get(value: 'true')
    get :show, id: reply.to_param, value: value
  end

  specify do
    expect { do_get(value:'true') }.to change { reply.reload.value }.to(true)
  end

  specify do
    expect { do_get(value:'false') }.to change { reply.reload.value }.to(false)
  end

  specify do
    do_get
    expect(response).to redirect_to(root_path)
  end
end
