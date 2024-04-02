# frozen_string_literal: true

class Tasks::CompletePostsController < ApplicationController
  before_action :check_hide_user
  before_action :set_task

  def new; end

  def create
    @task.update!(completed_at: Time.current)

    if CompletePost.create_with_timelines!(@task, current_user, complete_post_params)
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
