class ProposalsController < ApplicationController
  def new
    @proposal = Proposal.new
  end

  def create
    ProposalFlow.new.create_proposal(params[:proposal].permit(:proposer, :description, :stakeholder_emails).symbolize_keys)
    redirect_to root_path
  end

  def index
    @proposals = ProposalFlow.new.proposals
  end
end
