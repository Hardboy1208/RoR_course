require_relative '../acceptance_helper'

feature 'Show all questions', %q{
  In order to get answer from community
  I want to see questions
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 2) }

  background { questions }

  scenario 'Authenticated user see questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'Non-authenticated user see questions' do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end
