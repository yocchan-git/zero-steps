# frozen_string_literal: true

class Tasks::CommentsController < ApplicationController
  before_action :check_hide_user, only: %i[create]
  before_action :set_task

  COMMENT_COUNT = 5

  def index
    @comments = @task.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = Comment.create!(@task, current_user, comment_params)
    comment.create_notification_and_timeline

    respond_to do |format|
      format.html { redirect_to task_comments_path(@task) }
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
