require_relative '../acceptance_helper'

feature 'Best answer for question', %q{
  As an Author for the questions
  I want select best answer for the question
} do

  given(:author) { create(:user_with_question_and_answers) }
  given(:non_author) { create(:user) }

  scenario 'Author selected the best answer', js: true do
    sign_in(author)

    visit question_path(author.questions.first)

    within '.answers' do
      click_on 'Choose as the best'
      expect(page).to have_css('div.best', count: 1)
    end
  end

  scenario 'the best answer non select twice', js: true do
    sign_in(author)

    visit question_path(author.questions.first)

    within '.answers' do
      click_on 'Choose as the best'
      within '.best' do
        expect(page).to_not have_content('Choose as the best')
      end
    end
  end

  scenario 'Author selected new the best answer', js: true do
    sign_in(author)

    visit question_path(author.questions.first)

    within '.answers' do
      click_on 'Choose as the best'
      click_on 'Choose as the best'
      expect(page).to have_css('div.best', count: 1)
    end
  end

  scenario 'Non-Author selected the best answer', js: true do
    sign_in(non_author)

    visit question_path(author.questions.first)

    within '.answers' do
      expect(page).to_not have_content('Choose as the best')
    end
  end
end
