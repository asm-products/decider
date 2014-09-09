class ProposingMailerPreview < ActionMailer::Preview
  def proposal
    ProposingMailer.proposal(subject: '[Proposal from x] from xyz',
                             recipients: %w|x@example.com y@example.com|,
                             proposal: 'my proposal'
                            )
  end
end
