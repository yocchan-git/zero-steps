class Company < ApplicationRecord
  # バリデーションも追加する
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
end
