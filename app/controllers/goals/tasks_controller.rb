# frozen_string_literal: true

class Goals::TasksController < ApplicationController
  before_action :check_hide_user, only: %i[create update destroy]
  before_action :set_goal, only: %i[index show]
  before_action :set_current_user_goal, only: :create
  before_action :set_task, only: :show
  before_action :set_current_user_task, only: %i[update destroy]

  TASK_COUNTS = 5

  def index
    @tasks = @goal.tasks.order(created_at: :desc).page(params[:page]).per(TASK_COUNTS)
  end

  def show; end

  def create
    task_register = TaskRegister.new(@goal, task_params)
    task_register.execute

    @task = task_register.task

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end

  def update
    @task.update!(task_params)
    @is_tasks_path = params[:is_tasks_path]

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end

  def destroy
    @task.destroy!
    redirect_to goal_tasks_path(@task.goal), notice: 'タスクを削除しました'
  end

  private

  def task_params
    params.require(:task).permit(:content, :completion_limits)
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def set_task
    @task = @goal.tasks.find(params[:id])
  end

  def set_current_user_goal
    @goal = current_user.goals.find(params[:goal_id])
  end

  def set_current_user_task
    @task = current_user.tasks.find(params[:id])
  end
end
