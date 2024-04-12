# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[new callback failure]

  def new; end

  def callback
    auth_info = request.env['omniauth.auth']
    if (user_info = User.find_or_create_from_discord_info(auth_info))
      reset_session
      log_in user_info[:user]
    end

    flash[:notice] = 'ログインしました'
    if user_info[:is_new_user]
      redirect_to edit_user_path(current_user)
    else
      redirect_to root_path
    end
  end

  def failure
    redirect_to new_users_session_path, alert: 'キャンセルしました'
  end

  def destroy
    log_out
    redirect_to new_users_session_path, notice: 'ログアウトしました'
  end
end
