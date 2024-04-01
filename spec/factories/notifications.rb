# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    user
    comment
    content { 'コメントがありました' }
    is_read { false }

    trait :read do
      is_read { true }
    end
  end
end
