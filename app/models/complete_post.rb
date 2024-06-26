# frozen_string_literal: true

class CompletePost < ApplicationRecord
  has_many :reactions, as: :reactionable, dependent: :destroy
  has_many :timelines, as: :timelineable, dependent: :destroy
  belongs_to :user
  belongs_to :complete_postable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }
  validates :complete_postable_id, uniqueness: { scope: :complete_postable_type }
end
