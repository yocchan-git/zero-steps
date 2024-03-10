class Goals::CommentsController < ApplicationController
  before_action :set_goal

  COMMENT_COUNT = 5

  def index
    @comments = @goal.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @goal.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to goal_comments_path(@goal), notice: 'コメントを投稿しました'
    else
      @comments = @goal.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
      render 'goals/comments/index'
    end
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
