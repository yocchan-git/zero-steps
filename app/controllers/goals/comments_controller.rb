# frozen_string_literal: true

class Goals::CommentsController < ApplicationController
  before_action :set_goal

  COMMENT_COUNT = 5

  def index
    @comments = @goal.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @goal.comments.build(comment_params)
    comment.user = current_user

    comment.save!

    comment.create_mention_notification(goal_comments_url(@goal))
    Timeline.create!(user: current_user, content: "#{current_user.name}さんが#{@goal.formatted_title}にコメントしました", url: goal_comments_url(@goal))

    if comment.create_normal_notification? && !current_user?(@goal.user)
      Notification.create!(user: @goal.user, content: "#{@goal.formatted_title}に#{current_user.name}さんからコメントがありました",
                           url: goal_comments_url(@goal))
    end
    redirect_to request.referer, notice: 'コメントを投稿しました'
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
