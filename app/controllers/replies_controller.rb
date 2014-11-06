class RepliesController < ApplicationController
  def show
    flow = Replying.new(user: current_user, reply_id: params[:id])
    flow.reply(params[:value])
    redirect_to proposal_path(flow.proposal_id)
  end
end
