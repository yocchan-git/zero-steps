# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    # TODO: リファクタリングする
    @users =
      if params[:only_follows]
        current_user.following.includes(:goals, :tasks, :comments).order(created_at: :desc).page(params[:page])
      else
        User.includes(:goals, :tasks, :comments).order(created_at: :desc).page(params[:page])
      end
  end

  def show
    @user = User.find(params[:id])
  end
end
