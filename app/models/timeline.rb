# frozen_string_literal: true

class Timeline < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :timelineable, polymorphic: true

  validates :content, presence: true

  def timelineable_url
    case timelineable_type
    when 'Goal'
      goal_path(timelineable)
    when 'Task'
      goal_task_path(timelineable, goal_id: timelineable.goal.id)
    when 'Comment'
      timelineable.comment_url
    when 'CompletePost'
      timelineable.complete_post_url
    end
  end
end
