FactoryBot.define do
  factory :notification do
    association :user
    association :comment
    content { 'コメントがありました' }
    is_read { false }

    trait :read do
      is_read { true }
    end
  end
end
