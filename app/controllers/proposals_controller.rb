class ProposalsController < ApplicationController
  def new
    @possible_stakeholders = ProposalFlow.new(user: current_user).possible_stakeholders
  end

  def create
    permitted_params = params[:proposal].permit(
      :description,
      :user_ids => []
    ).symbolize_keys
    
    ProposalFlow.
      new(user: current_user).
      create_proposal(description: permitted_params[:description], stakeholder_ids: permitted_params[:user_ids])

    redirect_to root_path
  end

  def index
    @proposals = ProposalFlow.new(user: current_user).proposals
  end

  def show
    @proposal = ProposalFlow.new(user: current_user, proposal_id: params[:id]).proposal
    @adopt_proposal_path = proposal_path(params[:id], adopted: true)
    @reject_proposal_path = proposal_path(params[:id], adopted: false)
  end

  def update
    if params[:adopted] == 'true'
      ProposalFlow.new(user: current_user, proposal_id: params[:id]).adopt
    elsif params[:adopted] == 'false'
      ProposalFlow.new(user: current_user, proposal_id: params[:id]).reject
    end

    redirect_to proposal_path(params[:id])
  end
end
