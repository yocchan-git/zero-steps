FactoryBot.define do
  factory :goal do
    association :user
    title { "体重を50kgにする" }
    description { '最近太ってきたので、ダイエットをする' }
  end
end
