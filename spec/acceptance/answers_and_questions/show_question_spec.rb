require 'rails_helper'

feature 'Show question', %q{
  In order to get answer from community
  I want to see one question
} do

  given(:user) { create(:user) }
  given(:question_with_answer) { create(:question_for_answers) }

  background { question_with_answer }

  scenario 'Authenticated user see question' do
    sign_in(user)

    visit question_path(question_with_answer.id)

    expect(page).to have_content question_with_answer.title
    expect(page).to have_content question_with_answer.body

    question_with_answer.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authenticated user see question' do
    visit question_path(question_with_answer.id)

    expect(page).to have_content question_with_answer.title
    expect(page).to have_content question_with_answer.body
    question_with_answer.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
