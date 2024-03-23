# frozen_string_literal: true

class Goals::CommentsController < ApplicationController
  before_action :check_hide_user, only: %i[create]
  before_action :set_goal

  COMMENT_COUNT = 5

  def index
    @comments = @goal.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @goal.comments.build(comment_params)
    comment.user = current_user

    comment.save!

    comment.create_mention_notification
    comment.timelines.create!(user: current_user, content: "#{current_user.name}さんが#{@goal.formatted_title}にコメントしました")

    if comment.mention_other_than_commentable_user? && !current_user?(@goal.user)
      comment.notifications.create!(user: @goal.user, content: "#{@goal.formatted_title}に#{current_user.name}さんからコメントがありました")
      send_message_to_discord(comment, goal_comments_url(@goal))
    end
    redirect_back(fallback_location: root_path, notice: 'コメントを投稿しました')
  end

  private
  
  def send_message_to_discord(comment, url)
    Discordrb::API::Channel.create_message(
      "Bot #{ENV['DISCORD_BOT_TOKEN']}",
      ENV['DISCORD_CHANNEL_ID'],
      "<@#{comment.commentable.user.uid}>さん\n\n#{comment.commentable.formatted_title}に#{comment.user.name}さんからコメントがありました\n\nコメント本文\n「#{comment.formatted_content}」\n\n[詳細はこちら](#{url})"
    )
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
