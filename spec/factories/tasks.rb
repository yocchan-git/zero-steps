FactoryBot.define do
  factory :task do
    association :user
    association :goal
    content { '筋トレする' }
    completion_limits { '002024-4-01T00:00' }
  end
end
