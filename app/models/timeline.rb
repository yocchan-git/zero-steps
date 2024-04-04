# frozen_string_literal: true

class Timeline < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Timelineable

  TIMELINE_COUNT = 10

  belongs_to :user
  belongs_to :timelineable, polymorphic: true

  validates :content, presence: true

  def self.fetch_multiple(user:, is_only_follows: false, page_count: nil)
    if is_only_follows
      where(user_id: [*user.following_ids]).order(created_at: :desc).eager_load(:user).page(page_count).per(TIMELINE_COUNT)
    else
      order(created_at: :desc).eager_load(:user).page(page_count).per(TIMELINE_COUNT)
    end
  end

  def timelineable_url
    case timelineable_type
    when 'Goal'
      goal_path(timelineable)
    when 'Task'
      goal_task_path(timelineable, goal_id: timelineable.goal.id)
    when 'Comment'
      timelineable.url
    when 'CompletePost'
      complete_post_url
    end
  end

  private

  def complete_post_url
    complete_postable = timelineable.complete_postable

    if goal?(complete_postable)
      goal_path(complete_postable)
    else
      goal_task_path(complete_postable, goal_id: complete_postable.goal.id)
    end
  end
end
