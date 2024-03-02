class UsersController < ApplicationController
  before_action :check_can_edit_user, only: %i[edit update]

  def index
    @users = User.order(created_at: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit; end

  def update
    if current_user.update(user_params)
      redirect_to current_user, notice: '編集しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:dream)
  end

  def check_can_edit_user
    return redirect_to root_path alert: 'アクセスできません' if current_user.id != params[:id].to_i
  end
end
