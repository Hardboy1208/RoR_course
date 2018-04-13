require_relative '../acceptance_helper'

feature 'Add rating to question', %q{
  I want to vote for someone else's questions
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'The author can not vote for his question' do
    question
    sign_in(author)
    visit questions_path

    expect(page).to_not have_link '+1'
    expect(page).to_not have_link '-1'
    expect(page).to_not have_link '(0)'
  end

  scenario 'unauthorized user can not vote for his question' do
    question
    sign_in(author)
    visit questions_path

    expect(page).to_not have_link '+1'
    expect(page).to_not have_link '-1'
    expect(page).to_not have_link '(0)'
  end

  scenario 'The author can vote for his question' do
    question
    sign_in(non_author)
    visit questions_path

    expect(page).to have_content '(0)'
    click_on '+1'
    expect(page).to have_content '(1)'

    click_on 'Переголосовать'

    expect(page).to have_content '(0)'

    click_on '-1'
    expect(page).to have_content '(-1)'
  end
end