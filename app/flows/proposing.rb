class Proposing
  attr_reader :proposal

  def initialize(user:, proposal_id: nil)
    @user = user
    @proposal = Proposal.find_by(id: proposal_id)
  end

  def create_proposal(description:, stakeholder_ids:)
    @proposal = Proposal.create!(description: description, user: @user)

    User.where(id: (stakeholder_ids + [@user.id]).uniq).each do |stakeholder|
      reply = @proposal.replies.create!(user: stakeholder)
      deliver_new_proposal_notification(stakeholder, reply)
    end

    @proposal
  end

  def adopt
    proposal.update! adopted: true
    deliver_status_update
  end

  def reject
    proposal.update! adopted: false
    deliver_status_update
  end

  def possible_stakeholders
    User.where.not(id: @user.id)
  end

  private

  def deliver_new_proposal_notification(stakeholder, reply)
    ProposingMailer.propose(
      recipient: stakeholder.email,
      subject: "New proposal from #{proposal.user.name}",
      proposer: proposal.user.name,
      proposal: proposal.description,
      reply_id: reply.id
    ).deliver
  end

  def deliver_status_update
    proposal_presenter = ProposalPresenter.new(proposal)

    ProposingMailer.status_update(
      user_emails: proposal_presenter.user_emails,
      description: proposal_presenter.description,
      status: proposal_presenter.status
    ).deliver
  end
end

