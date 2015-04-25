class WelcomeController < ApplicationController
  skip_before_filter :require_login

  def index
    redirect_to proposals_path if logged_in?
  end
end
