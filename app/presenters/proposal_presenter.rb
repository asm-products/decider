class ProposalPresenter
  def self.map(proposals)
    proposals.map { |proposal| new(proposal) }
  end

  def initialize(proposal)
    @proposal = proposal
  end

  def id
    @proposal.to_param
  end

  def description
    @proposal.description
  end

  def proposer
    @proposal.user.name
  end

  def user_emails
    @proposal.users.map(&:email).sort
  end

  def status
    case @proposal.adopted
      when true then 'Adopted'
      when false then 'Rejected'
      else 'Pending'
    end
  end

  def has_decision?
    !@proposal.adopted.nil?
  end

  def replies
    ReplyPresenter.map(@proposal.replies)
  end

  def proposed_at
    @proposal.created_at
  end
end
