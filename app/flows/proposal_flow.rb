class ProposalFlow
  def self.for_new_proposal(description:, proposer:, proposer_email:, stakeholder_emails:)
    proposal = Proposal.create!(description: description, proposer: proposer)
    new(proposal).tap do |flow|
      parse_emails(stakeholder_emails, proposer_email).each do |email|
        flow.add_stakeholder(email)
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

  def add_stakeholder(stakeholder_email)
    stakeholder = Stakeholder.create!(email: stakeholder_email)
    reply = @proposal.replies.create!(stakeholder: stakeholder)

    ProposingMailer.propose(
      recipient: stakeholder_email,
      subject: "New proposal from #{@proposal.proposer}",
      proposer: @proposal.proposer,
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
      proposer: @proposal.proposer,
      stakeholder_emails: @proposal.stakeholders.map(&:email).sort,
      status: status
    }
  end

  def adopt
    @proposal.update! adopted: true
  end

  def reject
    @proposal.update! adopted: false
  end

  private

  def initialize(proposal)
    @proposal = proposal
  end

  def self.parse_emails(*email_strings)
    email_strings.each_with_object([]) do |email_string, emails|
      emails.concat email_string.strip.split /[\s,]+/
    end
  end
end

