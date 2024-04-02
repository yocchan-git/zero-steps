# frozen_string_literal: true

class CompletePost < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :complete_postable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }
  validates :complete_postable_id, uniqueness: { scope: :complete_postable_type }

  def self.create_with_timelines!(complete_postable, user, params)
    complete_post = complete_postable.build_complete_post(params)
    complete_post.user = user
    complete_post.save!

    message = complete_post.goal? ? complete_postable.formatted_title : complete_postable.formatted_content
    complete_post.timelines.create!(user:, content: "#{user.name}さんが#{message}という#{complete_post.goal? ? '目標' : 'タスク'}を終了しました")
  end

  def complete_post_url
    if goal?
      goal_path(complete_postable)
    else
      goal_task_path(complete_postable, goal_id: complete_postable.goal.id)
    end
  end

  def goal?
    complete_postable_type == 'Goal'
  end
end
