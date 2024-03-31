FactoryBot.define do
  factory :comment do
    association :user
    content { "応援しています！" }
    commentable_type { 'Goal' }
    association :commentable, factory: :goal

    trait :task do
      commentable_type { 'Task' }
      association :commentable, factory: :task
    end
  end
end
