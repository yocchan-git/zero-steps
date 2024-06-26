# frozen_string_literal: true

class Task < ApplicationRecord
  has_one :complete_post, as: :complete_postable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :goal

  validates :content, presence: true, length: { maximum: 500 }
  validates :completion_limits, presence: true

  scope :completed, -> { where.not(completed_at: nil) }
end
