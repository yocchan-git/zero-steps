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
      Discord::Notifier.message(create_embed(@goal, comment, goal_comments_url(@goal)))
    end
    redirect_back(fallback_location: root_path, notice: 'コメントを投稿しました')
  end

  private

  def create_embed(goal, comment, url)
    Discord::Embed.new do
      title "#{goal.formatted_title}にコメントがありました！"
      description "<@#{goal.user.uid}>さんに#{comment.user.name}さんからコメントがありました\n\nコメント本文\n「#{comment.formatted_content}」"
      color 16_083_556
      author name: comment.user.name,
             avatar_url: comment.user.image

      url url
      thumbnail url: comment.user.image
    end
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
