require_relative '../acceptance_helper'

feature 'Delete question', %q{
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
    question_title = user_with_question_and_answers.questions.first.title
    question_body  = user_with_question_and_answers.questions.first.body

    expect(page).to have_content question_title
    expect(page).to have_content question_body

    click_on 'Delete'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content question_title
    expect(page).to_not have_content question_body
  end

  scenario 'Non-author delete question' do
    question
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Non-authenticated delete question' do
    question
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
``