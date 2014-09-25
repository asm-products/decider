# == Schema Information
#
# Table name: replies
#
#  id             :integer          not null, primary key
#  value          :boolean
#  proposal_id    :integer
#  stakeholder_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Reply < ActiveRecord::Base
  belongs_to :stakeholder
  belongs_to :proposal

  validates :proposal, :stakeholder, presence: true
end
