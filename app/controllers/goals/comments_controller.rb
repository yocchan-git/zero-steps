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
    Timeline.create!(user: current_user, content: "#{current_user.name}さんが#{@goal.formatted_title}にコメントしました", url: goal_comments_url(@goal))
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
