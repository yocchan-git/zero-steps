# frozen_string_literal: true

class Comment < ApplicationRecord
  mentionable_as :content

  has_many :notifications, dependent: :destroy
  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }

  def goal?
    commentable_type == 'Goal'
  end

  def after_save_mention(new_mentions)
    # メンションされた後のメソッドだが、何もしない
  end

  # TODO: taskと全く同じなので、まとめる
  def formatted_content
    content.length <= 20 ? content : "#{content[0...20]}..."
  end

  def create_mention_notification
    mentions.each do |mention|
      mentioned_name = mention[1..]
      mentioned_user = User.find_by(name: mentioned_name)

      next unless mentioned_user

      notifications.create!(user: mentioned_user, content: "コメントで#{user.name}さんからメンションされました")
    end
  end

  def mention_other_than_commentable_user?
    commentable_user_name = commentable.user.name
    mentions.none?("@#{commentable_user_name}")
  end
end
