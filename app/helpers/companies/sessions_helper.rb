module Companies
  module SessionsHelper
    def log_in(company)
      session[:company_id] = company.id
    end
  end
end
