class RepliesController < ApplicationController
  def show
    Reply.find(params[:id]).update(value: params[:value])
    redirect_to root_path
  end
end
