# frozen_string_literal: true

class ReactionsController < ApplicationController
  def destroy
    @reaction = current_user.reactions.find(params[:id])
    @reaction.destroy!

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
