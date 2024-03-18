class UsersController < ApplicationController
  def index
    # TODO: リファクタリングする
    @users = 
      params[:only_follows] ?
        current_user.following.includes(:goals, :tasks, :comments).order(created_at: :desc).page(params[:page]) :
        User.includes(:goals, :tasks, :comments).order(created_at: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
