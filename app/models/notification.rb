# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  scope :recent, -> { where('created_at > ?', Time.current.ago(3.months)).order(created_at: :desc) }
  scope :recent_unread, -> { recent.where(is_read: false) }
end
