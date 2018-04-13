FactoryBot.define do
  factory :rating do
    retractable_type "MyString"
    retractable_id 1
    user_id 1
    like false
  end
end
