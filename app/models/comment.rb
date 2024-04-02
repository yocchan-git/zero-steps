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
      send_message_to_discord(send_user: mentioned_user, notification_type: :mention)
    end
  end

  def mention_other_than_commentable_user?
    commentable_user_name = commentable.user.name
    mentions.none?("@#{commentable_user_name}")
  end

  def comment_url
    goal? ? goal_comments_url(commentable) : task_comments_url(commentable)
  end

  def send_message_to_discord(send_user:, notification_type:)
    notification_type_word =
      case notification_type
      when :comment
        'コメント'
      when :mention
        'メンション'
      end

    Discordrb::API::Channel.create_message(
      "Bot #{ENV.fetch('DISCORD_BOT_TOKEN', nil)}",
      ENV.fetch('DISCORD_CHANNEL_ID', nil),
      "<@#{send_user.uid}>さん\n\n#{goal? ? commentable.formatted_title : commentable.formatted_content}に#{user.name}さんから
      #{notification_type_word}がありました\n\nコメント本文\n「#{formatted_content}」\n\n[詳細はこちら](#{comment_url})".delete(' ')
    )
  end
end
