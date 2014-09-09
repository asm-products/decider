class ProposalFlow
  def create_proposal(description:, proposer:, proposer_email:, stakeholder_emails:)
    proposal = Proposal.create!(description: description, proposer: proposer)
    stakeholder_emails = parse_emails(stakeholder_emails, proposer_email)

    stakeholder_emails.each do |email|
      proposal.stakeholders.create!(email: email)
    end

    ProposingMailer.propose(
      recipients: stakeholder_emails,
      subject: "New proposal from #{proposer}",
      proposal: description
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

