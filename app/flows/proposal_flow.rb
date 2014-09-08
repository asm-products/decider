class ProposalFlow
  def create_proposal(description:, proposer:)
    Proposal.create!(description: description, proposer: proposer)
  end

  def proposals
    Proposal.all.map {|x| x.attributes.slice('description', 'proposer').symbolize_keys }
  end
end

