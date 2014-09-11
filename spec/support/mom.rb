class Mom
  def reply
    Reply.new proposal: proposal, stakeholder: stakeholder
  end

  def proposal(description: 'wear beige', proposer: 'Paul Proposer', stakeholders: [])
    Proposal.new description: description, proposer: proposer, stakeholders: stakeholders
  end

  def proposal_with_stakeholders
    proposal(stakeholders: [stakeholder(email:'a@example.com'),
                            stakeholder(email: 'b@example.com')])
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
