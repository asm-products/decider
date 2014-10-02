class Mom
  def reply
    Reply.new proposal: proposal, user: user
  end

  def proposal(description: 'wear beige', proposer: create(:user, name: 'Paul Proposer'), stakeholders: [])
    Proposal.new description: description, user: proposer, users: stakeholders
  end

  def proposal_with_users
    proposal(stakeholders: [user, user])
  end

  def user(email: "user#{random}@example.com", name: 'name', password: 'password')
    User.new email: email, name: name, password: password
  end

  private

  def random
    rand(10**10)
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
