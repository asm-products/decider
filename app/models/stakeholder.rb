# == Schema Information
#
# Table name: stakeholders
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Stakeholder < ActiveRecord::Base
end
