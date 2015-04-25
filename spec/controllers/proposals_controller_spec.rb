require 'rails_helper'

RSpec.describe ProposalsController, type: :controller do
  describe '#new' do
    it 'assigns the possible stakeholders' do
      alice = create :user, name: 'alice'
      login_user alice
      create :user, name: 'billy'
      create :user, name: 'cindy'
      get :new
      expect(assigns(:possible_stakeholders).map(&:name)).to match_array %w[billy cindy]
    end
  end
end
