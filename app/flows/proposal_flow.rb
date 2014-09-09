class ProposalFlow
  def create_proposal(description:, proposer:, proposer_email:, stakeholder_emails:)
    proposal = Proposal.create!(description: description, proposer: proposer)
    stakeholder_emails = parse_emails(stakeholder_emails) << proposer_email
    (stakeholder_emails).each do |email|
      proposal.stakeholders.create!(email: email)
    end

    ProposingMailer.propose(recipients: stakeholder_emails, subject: '', proposal: '').deliver
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

