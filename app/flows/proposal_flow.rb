class ProposalFlow
  def initialize(user:, proposal_id: nil)
    @proposer = user
    @proposal = Proposal.find_by(id: proposal_id)
  end

  def create_proposal(description:, stakeholder_ids:)
    @proposal = Proposal.create!(description: description, user: @proposer)
    add_user(@proposer)
    User.where(id: stakeholder_ids).each { |user| add_user(user) }
  end

  def add_user(user)
    reply = @proposal.replies.create!(user: user)

    ProposingMailer.propose(
      recipient: user.email,
      subject: "New proposal from #{@proposal.user.name}",
      proposer: @proposal.user.name,
      proposal: @proposal.description,
      reply_id: reply.id
    ).deliver
  end

  def adopt
    @proposal.update! adopted: true
    deliver_status_update
  end

  def reject
    @proposal.update! adopted: false
    deliver_status_update
  end

  def proposal
    ProposalPresenter.new(@proposal)
  end

  def proposals
    ProposalPresenter.map(Proposal.newest_first)
  end

  def possible_stakeholders
    User.where.not(id: @proposer.id)
  end

  private

  def deliver_status_update
    ProposingMailer.
      status_update(user_emails: proposal.user_emails, description: proposal.description, status: proposal.status).
      deliver
  end
end

