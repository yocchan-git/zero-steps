# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user
    sequence(:content) { |n| "応援しています#{n}" }
    commentable_type { 'Goal' }
    commentable factory: %i[goal]

    trait :task do
      commentable_type { 'Task' }
      commentable factory: %i[task]
    end
  end
end
