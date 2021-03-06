FactoryBot.define do
  sequence :title do |n|
    "Title №#{n}"
  end

  factory :question do
    user
    title
    body "MyText"

    factory :question_for_answers do
      transient do
        answers_count 1
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end

    factory :question_with_five_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end

    factory :question_with_ratings do
      transient do
        ratings_count 10
      end

      after(:create) do |question, evaluator|
        create_list(:rating, evaluator.ratings_count, retractable: question, user_id: question.user.id, like: [-1, 1].sample)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    user nil
    title nil
    body nil
  end
end
