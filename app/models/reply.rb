class Reply < ActiveRecord::Base
  belongs_to :stakeholder
  belongs_to :proposal

  validates :proposal, :stakeholder, presence: true
end
