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
      comment.send_message_to_discord(:comment)
    end
    redirect_back(fallback_location: root_path, notice: 'コメントを投稿しました')
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
