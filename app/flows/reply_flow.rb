class ReplyFlow
  def initialize(user:, reply_id:)
    @user = user
    @reply = user.replies.find(reply_id)
  end

  def reply(value)
    @reply.update! value: value
  end

  def proposal_id
    @reply.proposal.id
  end
end
