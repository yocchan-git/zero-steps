# frozen_string_literal: true

class Comments::ReactionsController < ApplicationController
  def create
    @reactionable = Comment.find(params[:comment_id])
    reaction = @reactionable.reactions.build
    reaction.user = current_user

    reaction.save!
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
