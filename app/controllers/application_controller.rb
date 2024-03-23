# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :check_logged_in
  before_action :set_unread_notifications, if: :logged_in?

  def check_logged_in
    return if current_user

    redirect_to new_users_session_path
  end

  def check_hide_user
    return unless current_user.is_hidden

    redirect_to root_path, alert: '非公開のユーザーはアクセスできません'
  end

  private

  def set_unread_notifications
    @unread_notifications = current_user.notifications.recent_unread
  end
end
