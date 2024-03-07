class Goal < ApplicationRecord
  has_many :complete_posts, as: :complete_postable
  belongs_to :user

  validates :title, presence: true, length: { maximum: 256 }
  validates :description, presence: true
end
