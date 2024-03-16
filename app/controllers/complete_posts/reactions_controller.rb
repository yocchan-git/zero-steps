class CompletePosts::ReactionsController < ApplicationController
  def create
    @reactionable = CompletePost.find(params[:complete_post_id])
    reaction = @reactionable.reactions.build
    reaction.user = current_user

    reaction.save!
    respond_to do |format|
      format.html { redirect_to params[:redirect_uri] }
      format.turbo_stream
    end
  end
end
