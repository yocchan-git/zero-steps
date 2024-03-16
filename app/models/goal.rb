class Goal < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_one :complete_post, as: :complete_postable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true
end
