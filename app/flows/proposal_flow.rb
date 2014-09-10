class ProposalFlow
  def create_proposal(description:, proposer:, proposer_email:, stakeholder_emails:)
    proposal = Proposal.create!(description: description, proposer: proposer)

    parse_emails(stakeholder_emails, proposer_email).each do |email|
      add_stakeholder(email, proposal)
    end
  end

  def add_stakeholder(stakeholder_email, proposal)
    stakeholder = proposal.stakeholders.create!(email: stakeholder_email)
    reply = proposal.replies.create!(stakeholder_id: stakeholder.id)

    ProposingMailer.propose(
      recipient: stakeholder_email,
      subject: "New proposal from #{proposal.proposer}",
      proposal: proposal.description,
      reply_id: reply.id
    ).deliver
  end

  def proposals
    Proposal.all.map do |proposal|
      {
        description: proposal.description,
        proposer: proposal.proposer,
        stakeholder_emails: proposal.stakeholders.map(&:email).sort
      }
    end
  end

  private

  def parse_emails(*email_strings)
    email_strings.each_with_object([]) do |email_string, emails|
      emails.concat email_string.strip.split /[\s,]+/
    end
  end
end

