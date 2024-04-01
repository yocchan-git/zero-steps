FactoryBot.define do
  factory :comment do
    association :user
    sequence(:content) { |n| "応援しています#{n}" }
    commentable_type { 'Goal' }
    association :commentable, factory: :goal

    trait :task do
      commentable_type { 'Task' }
      association :commentable, factory: :task
    end
  end
end
