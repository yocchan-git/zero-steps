# frozen_string_literal: true

class FriendshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end

  def destroy
    @user = Friendship.find(params[:id]).followed
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
