FactoryBot.define do
  factory :complete_post do
    association :user
    content { "目標達成しました！応援ありがとうございました" }
    complete_postable_type { 'Goal' }
    association :complete_postable, factory: :goal

    trait :task do
      complete_postable_type { 'Task' }
      association :complete_postable, factory: :task
    end
  end
end
