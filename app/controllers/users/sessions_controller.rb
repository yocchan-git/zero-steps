# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: :new

  def new
    redirect_uri = new_users_session_url
    access_token = DiscordAuthentication.fetch_access_token(params[:code], redirect_uri)
    discord_account_information = DiscordAuthentication.fetch_discord_account_information(access_token)

    if user = find_or_create_from_discord_info(discord_account_information)
      log_in user
    end
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def find_or_create_from_discord_info(discord_account_information)
    User.find_or_create_by(uid: discord_account_information['id']) do |user|
      user.update!(
        uid: discord_account_information['id'],
        name: discord_account_information['username'],
        email: discord_account_information['email'],
        image: "https://cdn.discordapp.com/avatars/#{discord_account_information['id']}/#{discord_account_information['avatar']}"
      )
    end
  end
end
