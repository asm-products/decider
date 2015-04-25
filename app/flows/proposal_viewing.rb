class ProposalViewing
  def initialize(user)
    @user = user
  end

  def can_edit?(proposal_id)
    Proposal.where(id: proposal_id, user_id: @user.id).exists?
  end

  def proposal(id)
    ProposalPresenter.new(@user.proposals.find(id))
  end

  def proposals
    ProposalPresenter.map(@user.proposals.order('created_at desc'))
  end
end
