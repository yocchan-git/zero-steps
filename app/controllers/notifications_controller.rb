# frozen_string_literal: true

class NotificationsController < ApplicationController
  NOTIFICATION_COUNT = 10

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(NOTIFICATION_COUNT)
  end

  def show
    notification = Notification.find(params[:id])
    notification.update!(is_read: true) unless notification.is_read

    redirect_to notification.comment.comment_url
  end
end
