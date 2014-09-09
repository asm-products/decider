class ProposingMailer < ActionMailer::Base
  default from: "decider@citizencode.io"

  def propose(subject:, recipients:, proposal:)
    @proposal = proposal
    @subject = subject

    mail to: recipients, subject: subject
  end
end
