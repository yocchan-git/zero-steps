class TimelinesController < ApplicationController
  TIMELINE_COUNT = 10
  def index
    @timelines =
      params[:only_follows] ?
        Timeline.where(user_id: [*current_user.following_ids]).order(created_at: :desc).eager_load(:user).page(params[:page]).per(TIMELINE_COUNT) :
        Timeline.order(created_at: :desc).eager_load(:user).page(params[:page]).per(TIMELINE_COUNT)
  end
end
