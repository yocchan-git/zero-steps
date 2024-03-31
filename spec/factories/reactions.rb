FactoryBot.define do
  factory :reaction, class: Reaction do
    association :user

    trait :comment do
      reactionable_type { 'Comment' }
      association :reactionable, factory: :comment
    end

    trait :complete_post do
      reactionable_type { 'CompletePost' }
      association :reactionable, factory: :complete_post
    end
  end
end
