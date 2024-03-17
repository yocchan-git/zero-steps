class Goals::TasksController < ApplicationController
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

    if @task.save
      redirect_to params[:redirect_uri], notice: 'タスクを作成しました'
    else
      redirect_to params[:redirect_uri], alert: 'タスクの作成に失敗しました'
    end
  end

  def update
    if @task.update(task_params)
      redirect_to params[:redirect_uri], notice: 'タスクを更新しました'
    else
      redirect_to params[:redirect_uri], alert: 'タスクの更新に失敗しました'
    end
  end

  def destroy
    @task.destroy!
    redirect_to params[:redirect_uri], notice: '削除成功しました'
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