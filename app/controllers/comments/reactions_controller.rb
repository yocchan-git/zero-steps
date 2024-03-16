class Comments::ReactionsController < ApplicationController
  def create
    @reactionable = Comment.find(params[:comment_id])
    reaction = @reactionable.reactions.build
    reaction.user = current_user

    reaction.save!
    respond_to do |format|
      format.html { redirect_to params[:redirect_uri] }
      format.turbo_stream
    end
  end
end
