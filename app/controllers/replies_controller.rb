class RepliesController < ApplicationController
  def show
    reply = Reply.find(params[:id])
    reply.update(value: params[:value])
    redirect_to proposal_path(reply.proposal)
  end
end
