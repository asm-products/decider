class ProposingMailerPreview < ActionMailer::Preview
  def propose
    ProposingMailer.propose(
        subject: '[Proposal from x] from xyz',
        recipients: %w|x@example.com y@example.com|,
        proposal: 'my proposal'
      )
  end
end
