# frozen_string_literal: true

class CompletePosts::ReactionsController < ApplicationController
  def create
    @reactionable = CompletePost.find(params[:complete_post_id])
    @reactionable.reactions.create!(user: current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
