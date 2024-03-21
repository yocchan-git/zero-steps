# frozen_string_literal: true

class CommentsController < ApplicationController
  COMMENT_COUNT = 5

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!

    @comments = comment.commentable.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream
    end
  end
end
