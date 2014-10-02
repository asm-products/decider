# == Schema Information
#
# Table name: replies
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  proposal_id :integer
#  updated_at  :datetime
#  user_id     :integer
#  value       :boolean
#

class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :proposal

  validates :proposal, :user, presence: true
end
