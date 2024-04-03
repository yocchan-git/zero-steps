# frozen_string_literal: true

class TimelinesController < ApplicationController
  def index
    @timelines = Timeline.fetch_multiple(user: current_user, is_only_follows: params[:is_only_follows], page_count: params[:page])
  end
end
