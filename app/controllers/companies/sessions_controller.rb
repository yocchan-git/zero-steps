# frozen_string_literal: true

class Companies::SessionsController < ApplicationController
  include Companies::SessionsHelper

  skip_before_action :check_logged_in, only: %i[new create]

  def new; end

  def create
    company = Company.find_by(login_id: params[:session][:login_id])
    if company&.authenticate(params[:session][:password])
      reset_session
      log_in company
      redirect_to root_path, notice: 'ログインしました'
    else
      render 'new', status: :unprocessable_entity
    end
  end
end
