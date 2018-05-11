FactoryBot.define do
  factory :comment do
    body "MyString"
    user_id 1
    commentable_type "MyString"
    commentable_id 1
  end

  factory :invalid_comment, class: Comment do
    body ""
    user_id 1
    commentable_type "MyString"
    commentable_id 1
  end
end
