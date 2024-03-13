class Tasks::CompletePostsController < ApplicationController
  before_action :set_task

  def new; end

  def create
    @task.completed_at = Time.current
    @task.save!

    complete_post = @task.complete_posts.build(complete_post_params)
    complete_post.user = current_user

    if complete_post.save
      redirect_to goal_task_path(@task, goal_id: @task.goal.id), notice: '終了投稿しました'
    else
      render 'tasks/complete_posts/new'
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

  def complete_post_params
    params.require(:complete_post).permit(:content)
  end
end
