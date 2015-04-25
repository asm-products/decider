require "rails_helper"

RSpec.describe ProposalsController, type: :routing do
  describe "routing" do
    specify { expect(get: '/proposals/new').to route_to('proposals#new') }
  end
end
