FactoryBot.define do
  sequence :body do |n|
    "Body text №#{n}"
  end

  factory :answer do
    user
    question
    body

    factory :answer_with_ratings do
      transient do
        ratings_count 10
      end

      after(:create) do |answer, evaluator|
        create_list(:rating, evaluator.ratings_count, retractable: answer, user_id: answer.user.id, like: [-1, 1].sample)
      end
    end
  end

  factory :invalid_answer, class: Answer do
    user
    question
    body nil
  end
end
