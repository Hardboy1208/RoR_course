require 'rails_helper'

feature 'Delete question and answer', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user_with_question_and_answers) { create(:user_with_question_and_answers) }
  given(:user) { create(:user) }
  given(:question) { create(:question_for_answers) }

  scenario 'Author delete question' do
    sign_in(user_with_question_and_answers)

    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'Non-author delete question' do
    question
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Author delete answer' do
    sign_in(user_with_question_and_answers)

    visit question_path(user_with_question_and_answers.questions.first)
    click_on 'Delete'

    expect(page).to have_content 'Your answer successfully deleted.'
  end

  scenario 'Non-author delete answer' do
    question
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
