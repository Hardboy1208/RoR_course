require 'rails_helper'

feature 'Create answer for question', %q{
  In order to give answer for community
  As an authenticated user
  I want to be able to answer the question
} do

  given(:user) { create(:user) }

  given(:question) { create(:question) }

  background { question }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question.id)

    fill_in 'Body', with: 'test answer text for question'
    click_on 'Add answer'
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'test answer text for question'
  end

  scenario 'Non-authenticated user not create answer' do
    visit question_path(question.id)
    expect(page.has_content?('Add answer')).to eq false
    expect(page.has_content?('Body')).to eq false
  end
end
