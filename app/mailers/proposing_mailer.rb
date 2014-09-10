class ProposingMailer < ActionMailer::Base
  default from: "decider@citizencode.io"

  def propose(subject:, recipient:, proposal:, reply_id:)
    @proposal = proposal
    @subject = subject
    @reply_id = reply_id

    @objection_url = reply_url(@reply_id, value: false)
    @no_objection_url = reply_url(@reply_id, value: true)

    mail to: recipient, subject: subject
  end
end
