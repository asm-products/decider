class ReplyPresenter
  def self.map(replies)
    replies.map { |reply| new(reply) }
  end

  def initialize(reply)
    @reply = reply
  end

  def user_email
    @reply.user.email
  end

  def value
    case @reply.value
      when true then 'no objection'
      when false then 'objection'
      else 'no reply'
    end
  end
end
