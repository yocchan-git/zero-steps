class Task < ApplicationRecord
  has_one :complete_post, as: :complete_postable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user
  belongs_to :goal

  validates :content, presence: true, length: { maximum: 500 }
  validates :completion_limits, presence: true

  scope :completed, -> { where.not(completed_at: nil) }

  def formatted_content
    content.length <= 20 ? content : "#{content[0...20]}..."
  end
end
