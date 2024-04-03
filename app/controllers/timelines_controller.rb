# frozen_string_literal: true

class TimelinesController < ApplicationController
  def index
    @timelines = Timeline.fetch_multiple(current_user, params[:is_only_follows], params[:page])
  end
end
