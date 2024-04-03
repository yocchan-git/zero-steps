# frozen_string_literal: true

class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Timelineable

  mentionable_as :content

  has_many :notifications, dependent: :destroy
  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }

  def url
    goal?(commentable) ? goal_comments_url(commentable) : task_comments_url(commentable)
  end

  def after_save_mention(new_mentions)
    # メンションされた後のメソッド(必要)だが、何もしない
  end
end
