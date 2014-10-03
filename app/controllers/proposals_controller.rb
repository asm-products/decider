class ProposalsController < ApplicationController
  def new
    @possible_stakeholders = ProposalFlow.for_user(current_user)
  end

  def create
    permitted_params = params[:proposal].permit(
      :proposer_email,
      :description,
      :user_ids => []
    ).symbolize_keys

    proposer_id = User.find_by(email: permitted_params[:proposer_email]).id

    ProposalFlow.for_new_proposal(
      description: permitted_params[:description],
      proposer_id: proposer_id,
      stakeholder_ids: permitted_params[:user_ids]
    )

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
