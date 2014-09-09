require "rails_helper"

RSpec.describe ProposingMailer, type: :mailer do
  describe "proposal" do
    let(:mail) do
      ProposingMailer.propose(
        subject: "New proposal from J.R.R. Tolkein",
        recipients: %w[dadams@example.com oscard@example.com lalexander@example.com],
        proposal: "new elf world"
      )
    end

    it "renders the headers" do
      expect(mail.subject).to eq("New proposal from J.R.R. Tolkein")
      expect(mail.to).to match_array(%w[dadams@example.com oscard@example.com lalexander@example.com])
      expect(mail.from).to eq(["decider@citizencode.io"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("new elf world")
    end
  end
end
