class Proposal < ActiveRecord::Base
  has_many :stakeholders
  has_many :replies
end
