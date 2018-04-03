require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I`d like to be able to edit my answer
} do

  given!(:author) { create(:user_with_question_and_answers) }
  given(:non_author) { create(:user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(author.questions.first)

    expect(page).to_not have_link('Edit')
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in author
      visit question_path(author.questions.first)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'try to edit his answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content author.questions.first.answers.first
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'Non-author user try to edit other user`s question' do
    before do
      sign_in non_author
      visit question_path(author.questions.first)
    end

    scenario 'not sees link to Edit' do
      within '.answers' do
        expect(page).to_not have_link('Edit')
      end
    end
  end
end