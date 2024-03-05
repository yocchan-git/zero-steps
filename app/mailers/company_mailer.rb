class CompanyMailer < ApplicationMailer
  def password_reset(company)
    @company = company
    mail to: company.email, subject: "パスワード再設定"
  end
end
