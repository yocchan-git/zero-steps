# frozen_string_literal: true

FactoryBot.define do
  factory :timeline do
    user
    content { 'タイムラインが作成されました' }
    timelineable_type { 'Goal' }
    timelineable factory: %i[goal]

    trait :task do
      timelineable_type { 'Task' }
      timelineable factory: %i[task]
    end

    trait :comment do
      timelineable_type { 'Comment' }
      timelineable factory: %i[comment]
    end

    trait :complete_post do
      timelineable_type { 'CompletePost' }
      timelineable factory: %i[complete_post]
    end
  end
end
