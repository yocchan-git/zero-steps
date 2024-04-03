# frozen_string_literal: true

class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers

  mentionable_as :content

  has_many :notifications, dependent: :destroy
  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }

  def self.create!(commentable, user, comment_params)
    comment = commentable.comments.build(comment_params)
    comment.user = user
    comment.save!

    comment
  end

  def create_notification_and_timeline
    commentable_formatted_content = goal? ? commentable.formatted_title : commentable.formatted_content
    commentable_owner = commentable.user
    comment_owner = user

    create_mention_notification
    timelines.create!(user: comment_owner, content: "#{comment_owner.name}さんが#{commentable_formatted_content}にコメントしました")

    is_notificate_commentable_owner = mention_other_than_commentable_user? && user != commentable_owner
    if is_notificate_commentable_owner
      notifications.create!(user: commentable_owner, content: "#{commentable_formatted_content}に#{comment_owner.name}さんからコメントがありました")
      send_message_to_discord(send_user: commentable_owner, notification_type_word: 'コメント')
    end
  end

  def goal?
    commentable_type == 'Goal'
  end

  # TODO: taskと全く同じなので、まとめる
  def formatted_content
    content.length <= 20 ? content : "#{content[0...20]}..."
  end

  def comment_url
    goal? ? goal_comments_url(commentable) : task_comments_url(commentable)
  end

  def after_save_mention(new_mentions)
    # メンションされた後のメソッド(必要)だが、何もしない
  end

  private

  def create_mention_notification
    mentions.each do |mention|
      mentioned_name = mention[1..]
      mentioned_user = User.find_by(name: mentioned_name)

      next unless mentioned_user

      notifications.create!(user: mentioned_user, content: "コメントで#{user.name}さんからメンションされました")
      send_message_to_discord(send_user: mentioned_user, notification_type_word: 'メンション')
    end
  end

  def mention_other_than_commentable_user?
    commentable_user_name = commentable.user.name
    mentions.none?("@#{commentable_user_name}")
  end

  def send_message_to_discord(send_user:, notification_type_word:)
    Discordrb::API::Channel.create_message(
      "Bot #{ENV.fetch('DISCORD_BOT_TOKEN', nil)}",
      ENV.fetch('DISCORD_CHANNEL_ID', nil),
      "<@#{send_user.uid}>さん\n\n#{goal? ? commentable.formatted_title : commentable.formatted_content}に#{user.name}さんから
      #{notification_type_word}がありました\n\nコメント本文\n「#{formatted_content}」\n\n[詳細はこちら](#{comment_url})".delete(' ')
    )
  end
end
