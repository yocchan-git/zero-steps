# frozen_string_literal: true

FactoryBot.define do
  factory :reaction, class: 'Reaction' do
    user

    trait :comment do
      reactionable_type { 'Comment' }
      reactionable factory: %i[comment]
    end

    trait :complete_post do
      reactionable_type { 'CompletePost' }
      reactionable factory: %i[complete_post]
    end
  end
end
