class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(permitted_params[:email], permitted_params[:password])
      redirect_back_or_to(root_path)
    else
      @user ||= User.new
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path)
  end

  private

  def permitted_params
    params.require(:user).permit(%i[email password])
  end
end
