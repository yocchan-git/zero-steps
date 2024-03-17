class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :check_logged_in
  before_action :set_unread_notifications , if: :logged_in?

  def check_logged_in
    return if current_user

    redirect_to new_users_session_path
  end

  private

  def set_unread_notifications
    @unread_notifications = current_user.notifications.recent_unread
  end
end
