class Tasks::CompletePostsController < ApplicationController
  before_action :set_task

  def new; end

  def create
    @task.completed_at = Time.current
    @task.save!

    complete_post = @task.build_complete_post(complete_post_params)
    complete_post.user = current_user

    if complete_post.save
      Timeline.create!(user: current_user, content: "#{current_user.name}さんが#{@task.formatted_content}というタスクを終了しました", url: goal_task_url(@task, goal_id: @task.goal.id))
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
