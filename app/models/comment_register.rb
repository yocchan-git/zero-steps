class CommentRegister
  include Timelineable

  def initialize(commentable, user, params)
    @commentable = commentable
    @user = user
    @params = params
  end

  def execute
    @comment = create_comment
    create_timeline
    create_notifications
  end

  private

  def create_comment
    comment = @commentable.comments.build(@params)
    comment.user = @user
    comment.save!

    comment
  end

  def create_timeline
    @comment.timelines.create!(user: @user, content: "#{@user.name}さんが#{formatted_text(@commentable)}にコメントしました")
  end

  def create_notifications
    commentable_owner = @commentable.user
    create_mention_notification

    is_notificate_commentable_owner = @comment.mentions.none?("@#{@commentable.user.name}") && @user != commentable_owner
    return unless is_notificate_commentable_owner

    @comment.notifications.create!(user: commentable_owner, content: "#{formatted_text(@commentable)}に#{@user.name}さんからコメントがありました")
    send_message_to_discord(send_user: commentable_owner, notification_type_word: 'コメント')
  end

  def create_mention_notification
    @comment.mentions.each do |mention|
      mentioned_name = mention[1..]
      mentioned_user = User.find_by(name: mentioned_name)

      next unless mentioned_user

      @comment.notifications.create!(user: mentioned_user, content: "コメントで#{@user.name}さんからメンションされました")
      send_message_to_discord(send_user: mentioned_user, notification_type_word: 'メンション')
    end
  end

  def send_message_to_discord(send_user:, notification_type_word:)
    Discordrb::API::Channel.create_message(
      "Bot #{ENV.fetch('DISCORD_BOT_TOKEN', nil)}",
      ENV.fetch('DISCORD_CHANNEL_ID', nil),
      "<@#{send_user.uid}>さん\n\n#{formatted_text(@commentable)}に#{@user.name}さんから
      #{notification_type_word}がありました\n\nコメント本文\n「#{formatted_text(@comment)}」\n\n[詳細はこちら](#{@comment.comment_url})".delete(' ')
    )
  end
end
