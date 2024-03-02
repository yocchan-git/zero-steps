# frozen_string_literal: true

class SessionsController < ApplicationController
  def destroy
    log_out
    redirect_to new_users_session_path
  end
end
