class ProposalsController < ApplicationController
  def new
    @possible_stakeholders = Proposing.new(user: current_user).possible_stakeholders
    @proposal = Proposal.new
  end

  def create
    permitted_params = params[:proposal].permit(
      :description,
      :user_ids => []
    ).symbolize_keys
    
    Proposing.
      new(user: current_user).
      create_proposal(description: permitted_params[:description], stakeholder_ids: permitted_params[:user_ids])

    redirect_to root_path
  end

  def index
    @proposals = ProposalViewing.new(current_user).proposals
  end

  def show
    viewing = ProposalViewing.new(current_user)
    @proposal = viewing.proposal(params[:id])
    @show_actions = viewing.can_edit?(params[:id])
    @adopt_proposal_path = proposal_path(params[:id], adopted: true)
    @reject_proposal_path = proposal_path(params[:id], adopted: false)
  end

  def update
    if params[:adopted] == 'true'
      Proposing.new(user: current_user, proposal_id: params[:id]).adopt
    elsif params[:adopted] == 'false'
      Proposing.new(user: current_user, proposal_id: params[:id]).reject
    end

    redirect_to proposal_path(params[:id])
  end
end
