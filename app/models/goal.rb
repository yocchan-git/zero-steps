class Goal < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 256 }
  validates :description, presence: true
end
