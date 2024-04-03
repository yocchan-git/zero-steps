# frozen_string_literal: true

class Comments::ReactionsController < ApplicationController
  def create
    @reactionable = Comment.find(params[:comment_id])
    @reactionable.reactions.create!(user: current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
