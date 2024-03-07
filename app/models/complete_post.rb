class CompletePost < ApplicationRecord
  belongs_to :user
  belongs_to :complete_postable, polymorphic: true
end
