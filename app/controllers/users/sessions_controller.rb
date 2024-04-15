# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[new callback failure]

  def new; end

  def callback
    auth = request.env['omniauth.auth']
    if (authentication = User.auth_discord(auth))
      reset_session
      log_in authentication[:user]
    end

    flash[:notice] = 'ログインしました'
    if authentication[:is_new_user]
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
