class CompaniesController < ApplicationController
  include Companies::SessionsHelper

  skip_before_action :check_logged_in, only: %i[new create]

  def index
    @companies = Company.order(created_at: :desc).page(params[:page])
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      reset_session
      log_in(@company)
      redirect_to root_url, notice: '企業アカウント登録しました'
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :password, :password_confirmation, :industry, :description, :home_page_url)
  end
end
