# frozen_string_literal: true

class PagesController < ApplicationController
  include HighVoltage::StaticPage

  skip_before_action :check_logged_in
  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'home'
      'home'
    else
      'application'
    end
  end
end
