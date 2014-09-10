class Mom
  def build(thing)
    self.send(thing)
  end

  def create(thing)
    self.send(thing).tap(&:save!)
  end

  def reply
    Reply.new proposal: proposal, stakeholder: stakeholder
  end

  def proposal
    Proposal.new description: 'wear beige', proposer: 'Paul Proposer'
  end

  def stakeholder
    Stakeholder.new email: 'stakeholder@example.com'
  end
end

def mom
  @mom ||= Mom.new
end

def build(thing)
  mom.build(thing)
end

def create(thing)
  mom.create(thing)
end