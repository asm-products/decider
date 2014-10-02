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

require 'rails_helper'

describe Reply do
  let(:reply) { create :reply }

  specify { expect(reply).to be_valid }

  specify do
    reply.proposal = nil
    expect(reply).to_not be_valid
  end

  specify do
    reply.user = nil
    expect(reply).to_not be_valid
  end
end
