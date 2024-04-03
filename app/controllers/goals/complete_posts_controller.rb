# frozen_string_literal: true

class Goals::CompletePostsController < ApplicationController
  before_action :check_hide_user, only: %i[new create]
  before_action :set_goal

  def new; end

  def create
    @goal.update!(completed_at: Time.current)

    if CompletePost.create_with_timelines!(@goal, current_user, complete_post_params)
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
