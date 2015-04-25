class ProposingMailerPreview < ActionMailer::Preview
  def propose
    ProposingMailer.propose(
        subject: 'Proposal from J.R.R. Tolkein',
        proposer: 'J.R.R. Tolkein',
        recipient: 'x@example.com',
        proposal: 'new elf world',
        reply_id: 123
      )
  end

  def status_update
    ProposingMailer.status_update(
        stakeholder_emails: %w[a@example.com b@example.com],
        description: 'new elf world',
        status: 'Adopted'
      )
  end
end
