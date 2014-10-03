# == Schema Information
#
# Table name: proposals
#
#  adopted     :boolean
#  created_at  :datetime
#  description :text
#  id          :integer          not null, primary key
#  updated_at  :datetime
#  user_id     :integer
#

class Proposal < ActiveRecord::Base
  has_many :replies
  has_many :users, through: :replies
  belongs_to :user

  def self.newest_first
    order('created_at desc')
  end
end
