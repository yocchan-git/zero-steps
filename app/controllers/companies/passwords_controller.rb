class Companies::PasswordsController < ApplicationController
  include Companies::SessionsHelper

  skip_before_action :check_logged_in
  before_action :set_company,   only: [:edit, :update]
  before_action :valid_company, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @company = Company.find_by(email: params[:password_reset][:email].downcase)
    if @company
      @company.create_reset_digest
      @company.send_password_reset_email
      redirect_to root_url, notice: 'パスワード再設定メールを送りました'
    else
      flash.now[:danger] = "メールアドレスの企業が見つかりません"
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if company_params[:password].empty?
      @company.errors.add(:password, "空のパスワードは利用できません")
      render 'edit', status: :unprocessable_entity
    elsif @company.update(company_params)
      reset_session
      log_in @company
      redirect_to root_path, notice: 'パスワードを変更しました'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:password, :password_confirmation)
  end

  def set_company
    @company = Company.find_by(email: params[:email])
  end

  def valid_company
    unless (@company && @company.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration
    redirect_to new_companies_password_url, alert: 'パスワード再設定の有効期限切れです' if @company.password_reset_expired?
  end
end
