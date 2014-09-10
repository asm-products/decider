class Proposal < ActiveRecord::Base
  has_many :replies
  has_many :stakeholders, through: :replies
end
