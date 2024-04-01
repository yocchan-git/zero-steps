# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :user do
    uid { SecureRandom.hex(10) }
    sequence(:name) { |n| "yocchan#{n}" }
    image { 'https://hoge.example' }
    is_hidden { false }
  end
end
