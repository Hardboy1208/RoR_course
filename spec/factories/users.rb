FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'

    factory :user_with_question_and_answers do
     transient do
       question_count 1
     end

     after(:create) do |user|
       create(:question_for_answers, user: user)
     end
    end
  end
end
