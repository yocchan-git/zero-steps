class Goals::CommentsController < ApplicationController
  before_action :set_goal

  def index
    @comments = @goal.comments.order(created_at: :desc)
  end

  def create
    comment = @goal.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to goal_comments_path(@goal), notice: 'コメントを投稿しました'
    else
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
