# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    user
    goal
    content { '筋トレする' }
    completion_limits { '002024-4-01T00:00' }

    trait :completed do
      content { 'ジムに入会する' }
      completed_at { '002024-4-02T00:00' }
    end
  end
end
