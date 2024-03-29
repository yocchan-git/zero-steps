# frozen_string_literal: true

class Goals::TasksController < ApplicationController
  before_action :check_hide_user, only: %i[new edit create update destroy]
  before_action :set_goal, only: %i[index show]
  before_action :set_current_user_goal, only: :create
  before_action :set_task, only: :show
  before_action :set_current_user_task, only: %i[update destroy]

  def index
    @tasks = @goal.tasks.order(created_at: :desc).page(params[:page])
    @task = Task.new
  end

  def show; end

  def create
    @task = @goal.tasks.build(task_params)
    @task.user = current_user

    @task.save!
    @task.timelines.create!(user: current_user, content: "#{current_user.name}さんが#{@task.formatted_content}というタスクを作成しました")
    redirect_back(fallback_location: root_path, notice: 'タスクを作成しました')
  end

  def update
    @task.update!(task_params)
    redirect_back(fallback_location: root_path, notice: 'タスクを更新しました')
  end

  def destroy
    @task.destroy!
    redirect_back(fallback_location: root_path, notice: 'タスクを削除しました')
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
