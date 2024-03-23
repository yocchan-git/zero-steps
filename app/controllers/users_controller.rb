# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    # TODO: リファクタリングする
    @users =
      if params[:only_follows]
        current_user.following.active.includes(:goals, :tasks, :comments).order(created_at: :desc).page(params[:page])
      else
        User.active.includes(:goals, :tasks, :comments).order(created_at: :desc).page(params[:page])
      end
  end

  def show
    @user = User.find(params[:id])

    redirect_to users_path, alert: 'このユーザーにはアクセスできません'  if @user.is_hidden && !current_user?(@user)
  end

  def edit; end

  def update
    current_user.update!(user_params)
    redirect_to root_path, notice: 'ユーザー情報を更新しました'
  end

  private

  def user_params
    params.require(:user).permit(:is_hidden)
  end
end
