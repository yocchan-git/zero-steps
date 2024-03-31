FactoryBot.define do
  factory :timeline do
    association :user
    content { "タイムラインが作成されました" }
    timelineable_type { 'Goal' }
    association :timelineable, factory: :goal

    trait :task do
      timelineable_type { 'Task' }
      association :timelineable, factory: :task
    end

    trait :comment do
      timelineable_type { 'Comment' }
      association :timelineable, factory: :comment
    end

    trait :complete_post do
      timelineable_type { 'CompletePost' }
      association :timelineable, factory: :complete_post
    end
  end
end
