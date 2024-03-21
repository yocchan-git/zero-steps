# frozen_string_literal: true

class Comment < ApplicationRecord
  mentionable_as :content

  has_many :reactions, as: :reactionable, dependent: :destroy
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

  def create_mention_notification(redirect_uri)
    mentions.each do |mention|
      mentioned_name = mention[1..]
      mentioned_user = User.find_by(name: mentioned_name)

      next unless mentioned_user

      Notification.create!(user: mentioned_user, content: "コメントで#{user.name}さんからメンションされました", url: redirect_uri)
    end
  end

  def create_normal_notification?
    commentable_user_name = commentable.user.name
    mentions.include?("@#{commentable_user_name}")
  end
end
