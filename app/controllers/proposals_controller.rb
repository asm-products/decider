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
    @proposal = ProposalFlow.for_proposal(params[:id]).proposal
    @adopt_proposal_path = proposal_path(params[:id], adopted: true)
    @reject_proposal_path = proposal_path(params[:id], adopted: false)
  end

  def update
    if params[:adopted] == 'true'
      ProposalFlow.for_proposal(params[:id]).adopt
    elsif params[:adopted] == 'false'
      ProposalFlow.for_proposal(params[:id]).reject
    end

    redirect_to proposal_path(params[:id])
  end
end
