# frozen_string_literal: true

class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :comment

  # 3ヶ月以内の通知を取得
  scope :recent, -> { where('created_at > ?', Time.current.ago(3.months)).order(created_at: :desc) }
  scope :recent_unread, -> { recent.where(is_read: false) }

  def comment_url
    if comment.goal?
      goal_comments_path(comment)
    else
      task_comments_path(comment)
    end
  end
end
