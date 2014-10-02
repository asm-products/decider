class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(%i[name email password])
    if @user.save
      auto_login @user
      redirect_to proposals_path
    else
      render action: :new
    end
  end
end
