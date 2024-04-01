FactoryBot.define do
  factory :goal do
    association :user
    title { "体重を50kgにする" }
    description { '最近太ってきたので、ダイエットをする' }

    trait :completed do
      completed_at { '002024-4-02T00:00' }
    end
  end
end
