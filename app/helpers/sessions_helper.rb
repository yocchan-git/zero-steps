module SessionsHelper
  def current_user
    return unless session[:user_id] || session[:company_id]

    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif session[:company_id]
      @current_user ||= Company.find_by(id: session[:company_id])
    end
  end

  def log_out
    reset_session
    @current_user = nil
  end

  def using_personal?
    !!session[:user_id]
  end
end
