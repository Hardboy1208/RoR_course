require 'rails_helper'

feature 'Create answer for question', %q{
  In order to give answer for community
  As an authenticated user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }

  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: 'test answer text for question'
    click_on 'Add answer'
    expect(page).to have_content 'Your answer successfully created.'

    within '.answers' do
      expect(page).to have_content 'test answer text for question'
    end
  end

  scenario 'Authenticated user creates not valid answer', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Add answer'
    expect(page).to_not have_content 'Your answer successfully created.'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user not create answer' do
    visit question_path(question.id)
    expect(page).to_not have_content 'Add answer'
    expect(page).to_not have_content 'Body'
  end
end
