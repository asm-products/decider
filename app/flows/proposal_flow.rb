class ProposalFlow
  def self.for_new_proposal(description:, proposer_id:, stakeholder_ids:)
    proposer = User.find(proposer_id)
    proposal = Proposal.create!(description: description, user: proposer)
    new(proposal).tap do |flow|
      flow.add_user(proposer)
      User.where(id: stakeholder_ids).each do |user|
        flow.add_user(user)
      end
    end
  end

  def self.for_proposal(proposal_id)
    new(Proposal.find(proposal_id))
  end

  def self.all_proposals
    Proposal.order('created_at desc').map do |proposal|
      new(proposal).proposal
    end
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

  def proposal
    status = case @proposal.adopted
      when true then 'Adopted'
      when false then 'Rejected'
      else 'Pending'
    end

    {
      id: @proposal.to_param,
      description: @proposal.description,
      proposer: @proposal.user.name,
      user_emails: @proposal.users.map(&:email).sort,
      status: status,
      has_decision: !@proposal.adopted.nil?,
      replies: replies
    }
  end

  def replies
    @proposal.replies.map do |reply|
      {}.tap do |hash|
        hash[:user_email] = reply.user.email

        hash[:value] = case reply.value
          when true then 'no objection'
          when false then 'objection'
          else 'no reply'
        end
      end
    end
  end

  def adopt
    @proposal.update! adopted: true
    deliver_status_update
  end

  def reject
    @proposal.update! adopted: false
    deliver_status_update
  end

  private

  def deliver_status_update
    ProposingMailer.
      status_update(proposal.slice(:user_emails, :description, :status)).
      deliver
  end

  def initialize(proposal)
    @proposal = proposal
  end

  def self.parse_emails(*email_strings)
    email_strings.each_with_object([]) do |email_string, emails|
      emails.concat email_string.strip.split /[\s,]+/
    end
  end
end

