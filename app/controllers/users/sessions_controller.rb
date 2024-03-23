# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: %i[new callback]

  def new; end

  def callback
    auth_hash = request.env['omniauth.auth']
    if (user = find_or_create_from_discord_info(auth_hash))
      reset_session
      log_in user
    end
    redirect_to root_path, notice: 'ログインしました'
  end

  def failure
    redirect_to new_users_session_path, alert: 'キャンセルしました'
  end

  def destroy
    log_out
    redirect_to new_users_session_path
  end

  private

  def find_or_create_from_discord_info(auth_hash)
    puts auth_hash
    puts '--------------------'
    User.find_or_create_by(uid: auth_hash.uid) do |user|
      user.update!(
        uid: auth_hash.uid,
        name: auth_hash.info.name,
        image: auth_hash.info.image,
      )
    end
  end
end
