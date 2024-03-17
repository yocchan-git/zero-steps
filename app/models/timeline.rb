class Timeline < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :url, presence: true
end
