class ReactionsController < ApplicationController
  def destroy
    @reaction = current_user.reactions.find(params[:id])
    @reaction.destroy!

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream
    end
  end
end
