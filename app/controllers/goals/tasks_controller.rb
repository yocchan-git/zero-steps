class Goals::TasksController < ApplicationController
  before_action :set_goal, only: %i[index show]
  before_action :set_current_user_goal, only: %i[new create edit]
  before_action :set_task, only: %i[show edit]
  before_action :set_current_user_task, only: %i[update destroy]

  def index
    @tasks = @goal.tasks.order(created_at: :desc).page(params[:page])
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = @goal.tasks.build(task_params)
    @task.user = current_user

    if @task.save
      redirect_to goal_tasks_path(@goal), notice: 'タスクを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to goal_task_path(@task, goal_id: @task.goal.id), notice: 'タスクを更新しました'
    else
      puts @task.errors
      render 'goals/tasks/edit'
    end
  end

  def destroy
    @task.destroy!
    redirect_to goal_tasks_path(@task.goal), notice: '削除成功しました'
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
