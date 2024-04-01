# frozen_string_literal: true

FactoryBot.define do
  factory :complete_post do
    user
    content { '目標達成しました！応援ありがとうございました' }
    complete_postable_type { 'Goal' }
    complete_postable factory: %i[goal]

    trait :task do
      complete_postable_type { 'Task' }
      complete_postable factory: %i[task]
    end
  end
end
