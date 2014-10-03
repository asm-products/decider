class ProposalFlow
  def initialize(proposer:, proposal_id: nil)
    @proposer = proposer
    @proposal = Proposal.find_by(id: proposal_id)
  end

  def create_proposal(description:, stakeholder_ids:)
    @proposal = Proposal.create!(description: description, user: @proposer)
    add_stakeholder(@proposer)
    User.where(id: stakeholder_ids).each { |stakeholder| add_stakeholder(stakeholder) }
  end

  def add_stakeholder(stakeholder)
    reply = @proposal.replies.create!(user: stakeholder)

    ProposingMailer.propose(
      recipient: stakeholder.email,
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

