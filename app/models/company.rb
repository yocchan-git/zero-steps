class Company < ApplicationRecord
  attr_accessor :reset_token

  validates :name, presence: true, length: { maximum: 255 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                                    format: {with: VALID_EMAIL_REGEX},
                                    uniqueness: true
  validates :industry, length: { maximum: 255 }
  validates :description, length: { maximum: 500 }
  validate :valid_home_page_url
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def create_reset_digest
    self.reset_token = Company.new_token
    update_columns(reset_digest: Company.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    CompanyMailer.password_reset(self).deliver_now
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def valid_home_page_url
    unless home_page_url || URI::DEFAULT_PARSER.make_regexp.match(home_page_url).present?
      errors.add(:home_page_url, 'is not a valid URL')
    end
  end
end
