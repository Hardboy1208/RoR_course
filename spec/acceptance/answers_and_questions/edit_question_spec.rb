require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of question
  I`d like to be able to edit my question
} do

  given!(:author) { create(:user_with_question_and_answers) }
  given(:non_author) { create(:user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(author.questions.first)

    within '.question' do
      expect(page).to_not have_link('Edit')
    end
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in author
      visit question_path(author.questions.first)
    end

    scenario 'sees link to Edit' do
      within '.question' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'try to edit his answer' do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title question'
        fill_in 'Body', with: 'edited body question'
        click_on 'Save'
        expect(page).to_not have_content author.questions.first
        expect(page).to have_content 'edited title question'
        expect(page).to have_content 'edited body question'
        expect(page).to_not have_css 'edit_answer'
      end
    end
  end

  describe 'Non-author user try to edit other user`s question' do
    before do
      sign_in non_author
      visit question_path(author.questions.first)
    end

    scenario 'not sees link to Edit' do
      within '.question' do
        expect(page).to_not have_link('Edit')
      end
    end
  end
end