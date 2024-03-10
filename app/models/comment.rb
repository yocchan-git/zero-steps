class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }

  def goal?
    commentable_type == 'Goal'
  end
end
