class ProposalFlow
  def create_proposal(description:, proposer:, proposer_email:, stakeholder_emails:)
    proposal = Proposal.create!(description: description, proposer: proposer)

    (parse_emails(stakeholder_emails) << proposer_email).each do |email|
      proposal.stakeholders.create!(email: email)
    end
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

  def parse_emails(email_string)
    email_string.strip!
    email_string.split /[\s,]+/
  end
end

