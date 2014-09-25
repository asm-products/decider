# == Schema Information
#
# Table name: proposals
#
#  id          :integer          not null, primary key
#  description :text
#  proposer    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  adopted     :boolean
#

class Proposal < ActiveRecord::Base
  has_many :replies
  has_many :stakeholders, through: :replies
end
