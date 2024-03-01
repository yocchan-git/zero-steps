# frozen_string_literal: true

class User < ApplicationRecord
  has_many :goals, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :uid, presence: true
end
