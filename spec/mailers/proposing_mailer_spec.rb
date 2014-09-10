require "rails_helper"

RSpec.describe ProposingMailer, type: :mailer do
  describe "proposal" do
    let(:mail) do
      ProposingMailer.propose(
        subject: "New proposal from J.R.R. Tolkein",
        proposer: 'J.R.R. Tolkein',
        recipient: 'dadams@example.com',
        proposal: "new elf world",
        reply_id: 123
      )
    end

    it "renders the headers" do
      expect(mail.subject).to eq("New proposal from J.R.R. Tolkein")
      expect(mail.to).to eq(['dadams@example.com'])
      expect(mail.from).to eq(["decider@citizencode.io"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include 'J.R.R. Tolkein proposed new elf world'
      expect(mail.body.encoded).to include 'http://test.host/replies/123?value=true'
      expect(mail.body.encoded).to include 'http://test.host/replies/123?value=false'
    end
  end
end
