class Tasks::CommentsController < ApplicationController
  before_action :set_task

  COMMENT_COUNT = 5

  def index
    @comments = @task.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @task.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to request.referer, notice: 'コメントを投稿しました'
    else
      @comments = @task.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
      render 'tasks/comments/index'
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
