# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user

  # 3ヶ月以内の通知を取得
  scope :recent, -> { where('created_at > ?', Time.current.ago(3.months)).order(created_at: :desc) }
  scope :recent_unread, -> { recent.where(is_read: false) }
end
