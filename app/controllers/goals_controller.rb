class GoalsController < ApplicationController
  before_action :set_goal, only: %i[edit update destroy]

  def index
    @goals = Goal.order(created_at: :desc)
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def new
    @goal = Goal.new
  end

  def edit; end

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      redirect_to @goal, notice: '目標を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @goal.update(goal_params)
      redirect_to @goal, notice: '編集しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal.destroy

    redirect_to root_path
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:title, :description)
  end
end
