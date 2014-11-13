class ProposalViewing
  def initialize(user)
    @user = user
  end

  def proposal(id)
    ProposalPresenter.new(@user.proposals.find(id))
  end

  def proposals
    ProposalPresenter.map(@user.proposals.order('created_at desc'))
  end
end
