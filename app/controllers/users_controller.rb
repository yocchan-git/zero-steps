class UsersController < ApplicationController
  def index
    @users = User.includes(:goals, :comments).order(created_at: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
