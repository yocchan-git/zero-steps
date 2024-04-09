# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :check_hide_user

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
