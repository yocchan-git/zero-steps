# frozen_string_literal: true

class Timeline < ApplicationRecord
  belongs_to :user
  belongs_to :timelineable, polymorphic: true

  validates :content, presence: true
end
