class ProposingMailerPreview < ActionMailer::Preview
  def propose
    ProposingMailer.propose(
        subject: 'Proposal from fred',
        recipient: 'x@example.com',
        proposal: 'my proposal',
        reply_id: 123
      )
  end
end
