require 'rails_helper'

describe Reply do
  let(:reply) { create :reply }

  specify { expect(reply).to be_valid }

  specify do
    reply.proposal = nil
    expect(reply).to_not be_valid
  end

  specify do
    reply.stakeholder = nil
    expect(reply).to_not be_valid
  end
end