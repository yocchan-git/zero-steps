class Goals::CompletePostsController < ApplicationController
  before_action :set_goal

  def new; end

  def create
    @goal.completed_at = Time.current
    @goal.save!

    complete_post = @goal.complete_posts.build(complete_post_params)
    complete_post.user = current_user

    if complete_post.save
      redirect_to @goal, notice: '終了投稿しました'
    else
      render 'goals/complete_posts/new'
    end
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:goal_id])
  end

  def complete_post_params
    params.require(:complete_post).permit(:content)
  end
end
