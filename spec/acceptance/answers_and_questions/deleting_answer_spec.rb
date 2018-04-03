require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user_with_question_and_answers) { create(:user_with_question_and_answers) }
  given(:user) { create(:user) }
  given(:question) { create(:question_for_answers) }

  scenario 'Author delete answer', js: true do
    answer_body = user_with_question_and_answers.questions.first.answers.first.body

    sign_in(user_with_question_and_answers)

    visit question_path(user_with_question_and_answers.questions.first)
    expect(page).to have_content answer_body
    click_on 'Delete'

    expect(page).to have_content 'Your answer successfully deleted.'
    expect(page).to_not have_content answer_body
  end

  scenario 'Non-author delete answer' do
    question
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Non-authenticated delete answer' do
    question
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
