# frozen_string_literal: true

class NotificationsController < ApplicationController
  NOTIFICATION_COUNT = 10

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(NOTIFICATION_COUNT)
  end

  def show
    notification = Notification.find(params[:id])

    # TODO: ここモデルに移行する
    unless notification.is_read
      notification.is_read = true
      notification.save!
    end

    redirect_to notification.comment_url
  end
end
