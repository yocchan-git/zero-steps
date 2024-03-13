class Task < ApplicationRecord
  has_many :complete_posts, as: :complete_postable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user
  belongs_to :goal

  validates :content, presence: true
  validates :completion_limits, presence: true

  scope :completed, -> { where.not(completed_at: nil) }
end
