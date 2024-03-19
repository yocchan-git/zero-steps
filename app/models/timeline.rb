# frozen_string_literal: true

class Timeline < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :url, presence: true
end
