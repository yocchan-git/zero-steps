# frozen_string_literal: true

class CompletePosts::ReactionsController < ApplicationController
  def create
    @reactionable = CompletePost.find(params[:complete_post_id])
    reaction = @reactionable.reactions.build
    reaction.user = current_user

    reaction.save!
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream
    end
  end
end
