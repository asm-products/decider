class ProposalsController < ApplicationController
  def new
  end

  def create
    ProposalFlow.for_new_proposal(
        params[:proposal].permit(
            :proposer,
            :proposer_email,
            :description,
            :stakeholder_emails
          ).symbolize_keys)

    redirect_to root_path
  end

  def index
    @proposals = ProposalFlow.all_proposals
  end

  def show
    @proposal = Proposal.find(params[:id])
    # @proposal = ProposalFlow.for_proposal_id(params[:id]).proposal
  end
end
