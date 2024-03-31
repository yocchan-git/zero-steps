# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[new callback failure]

  def new; end

  def callback
    auth_hash = request.env['omniauth.auth']
    if (user = find_or_create_from_discord_info(auth_hash))
      reset_session
      log_in user
    end

    flash[:notice] = 'ログインしました'
    return redirect_to edit_user_path(current_user) if @is_new_user
    redirect_to root_path
  end

  def failure
    redirect_to new_users_session_path, alert: 'キャンセルしました'
  end

  def destroy
    log_out
    redirect_to new_users_session_path, notice: 'ログアウトしました'
  end

  private

  def find_or_create_from_discord_info(auth_hash)
    @is_new_user = false
    User.find_or_create_by(uid: auth_hash.uid) do |user|
      user.update!(
        uid: auth_hash.uid,
        name: auth_hash.info.name,
        image: auth_hash.info.image,
      )
      @is_new_user = true
    end
  end
end
