class CompletePost < ApplicationRecord
  has_many :reactions, as: :reactionable, dependent: :destroy
  belongs_to :user
  belongs_to :complete_postable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }
end
