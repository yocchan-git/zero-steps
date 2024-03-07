# frozen_string_literal: true

class User < ApplicationRecord
  has_many :goals, dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true
end
