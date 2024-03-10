class CompletePost < ApplicationRecord
  belongs_to :user
  belongs_to :complete_postable, polymorphic: true

  validates :content, presence: true, length: { maximum: 500 }
end
