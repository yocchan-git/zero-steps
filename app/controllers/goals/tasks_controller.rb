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
    @goal.create_task_and_timeline!(task_params)
    redirect_back(fallback_location: root_path, notice: 'タスクを作成しました')
  end

  def update
    @task.update!(task_params)
    redirect_back(fallback_location: root_path, notice: 'タスクを更新しました')
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
