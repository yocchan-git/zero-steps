class Company < ApplicationRecord
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

  private

  def valid_home_page_url
    unless home_page_url =~ /\Ahttps?:\/\/.*\z/ || URI::DEFAULT_PARSER.make_regexp.match(home_page_url).present?
      errors.add(:home_page_url, 'is not a valid URL')
    end
  end
end
