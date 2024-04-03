# frozen_string_literal: true

class Goals::CommentsController < ApplicationController
  before_action :check_hide_user, only: %i[create]
  before_action :set_goal

  COMMENT_COUNT = 5

  def index
    @comments = @goal.comments.eager_load(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment_register = CommentRegister.new(@goal, current_user, comment_params)
    comment_register.execute

    respond_to do |format|
      format.html { redirect_to goal_comments_path(@goal) }
      format.turbo_stream
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
