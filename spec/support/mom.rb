class Mom
  def reply
    Reply.new proposal: proposal, stakeholder: stakeholder
  end

  def proposal(description: 'wear beige', proposer: 'Paul Proposer')
    Proposal.new description: description, proposer: proposer
  end

  def stakeholder(email: 'stakeholder@example.com')
    Stakeholder.new email: email
  end
end

def mom
  @mom ||= Mom.new
end

def build(thing, *args)
  mom.send(thing, *args)
end

def create(thing, *args)
  mom.send(thing, *args).tap(&:save!)
end
