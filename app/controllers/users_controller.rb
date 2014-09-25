class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.create! params.require(:user).permit(%i[name email password])
    auto_login user
    redirect_to proposals_path
  end
end
