class Tasks::CommentsController < ApplicationController
  before_action :set_task

  COMMENT_COUNT = 5

  def index
    @comments = @task.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @task.comments.build(comment_params)
    comment.user = current_user

    comment.save!
    Timeline.create!(user: current_user, content: "#{current_user.name}さんが#{@task.formatted_content}にコメントしました", url: task_comments_url(@task))
    Notification.create!(user: @task.user, content: "#{@task.formatted_content}に#{current_user.name}さんからコメントがありました", url: task_comments_url(@task)) if !current_user?(@task.user)
    redirect_to request.referer, notice: 'コメントを投稿しました'
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
