# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.fetch_multiple(user: current_user, is_only_follows: params[:is_only_follows], page_count: params[:page])
  end

  def show
    @user = User.find(params[:id])

    redirect_to users_path, alert: 'このユーザーにはアクセスできません' if @user.is_hidden && !current_user?(@user)
  end

  def edit; end

  def update
    current_user.update!(user_params)
    redirect_to current_user, notice: 'ユーザー情報を更新しました'
  end

  private

  def user_params
    params.require(:user).permit(:is_hidden, :self_introduction)
  end
end
