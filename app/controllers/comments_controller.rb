# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :check_hide_user

  COMMENT_COUNT = 5

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!

    @comments = comment.commentable.comments.eager_load(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
