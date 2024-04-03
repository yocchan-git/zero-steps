# frozen_string_literal: true

class CompletePost < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :complete_postable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }
  validates :complete_postable_id, uniqueness: { scope: :complete_postable_type }

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
