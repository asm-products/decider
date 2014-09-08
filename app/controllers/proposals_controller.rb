class ProposalsController < ApplicationController
  def new
    @proposal = Proposal.new
  end

  def create
    ProposalFlow.new.create_proposal(params[:proposal].permit(:proposer, :description).symbolize_keys)
    redirect_to proposals_path
  end

  def index
    @proposals = ProposalFlow.new.proposals
  end
end
