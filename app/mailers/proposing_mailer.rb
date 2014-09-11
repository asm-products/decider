class ProposingMailer < ActionMailer::Base
  default from: "decider@citizencode.io"

  def propose(subject:, recipient:, proposal:, reply_id:, proposer:)
    @proposal = proposal
    @reply_id = reply_id
    @proposer = proposer

    @objection_url = reply_url(@reply_id, value: false)
    @no_objection_url = reply_url(@reply_id, value: true)

    mail to: recipient, subject: subject
  end

  def status_update(stakeholder_emails:,description:,status:)
    @description = description
    @status = status
    mail to: stakeholder_emails, subject: "Proposal #{status}: #{description}"
  end
end
