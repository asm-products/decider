require "rails_helper"

describe UsersController do
  describe '#create' do
    it 'handles invalid users' do
      post :create, user: { password: 'password' }
      expect(response).to render_template 'users/new'
      expect(assigns(:user)).to be_new_record
    end
  end
end
