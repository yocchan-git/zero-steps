class Goals::TasksController < ApplicationController
  def index
    @goal = Goal.find(params[:goal_id])
    @tasks = @goal.tasks.order(created_at: :desc).page(params[:page])
  end

  def show
    @goal = Goal.find(params[:goal_id])
    @task = @goal.tasks.find(params[:id])
  end

  def new
    @goal = current_user.goals.find(params[:goal_id])
    @task = Task.new
  end

  def create
    @goal = current_user.goals.find(params[:goal_id])
    @task = @goal.tasks.build(task_params)
    @task.user = current_user

    if @task.save
      redirect_to goal_tasks_path(@goal), notice: 'タスクを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @goal = current_user.goals.find(params[:goal_id])
    @task = @goal.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to goal_task_path(@task, goal_id: @task.goal.id), notice: 'タスクを更新しました'
    else
      puts @task.errors
      render 'goals/tasks/edit'
    end
  end

  def destroy
    task = current_user.tasks.find(params[:id])
    task.destroy!

    redirect_to goal_tasks_path(task.goal), notice: '削除成功しました'
  end

  private

  def task_params
    params.require(:task).permit(:content, :completion_limits)
  end
end
