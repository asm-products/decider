class Mom
  def reply(proposal: proposal(), user: user())
    Reply.new proposal: proposal, user: user
  end

  def proposal(description: 'wear beige', proposer: create(:user, name: 'Paul Proposer'))
    Proposal.new(description: description, user: proposer)
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
