require_relative '../acceptance_helper'

feature 'Create comment' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_with_answer) { create(:question_for_answers) }

  context 'multiple sessions' do
    scenario 'comment for question appears on another user`s page`', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Body', with: 'comment for question'
          click_on 'Add comment'
          expect(page).to have_content 'comment for question'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'comment for question'
        end
      end
    end
  end

  context 'multiple sessions' do
    scenario 'comment for answer appears on another user`s page`', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question_with_answer)
      end

      Capybara.using_session('guest') do
        visit question_path(question_with_answer)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Body', with: 'comment for answer'
          click_on 'Add comment'
          expect(page).to have_content 'comment for answer'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'comment for answer'
        end
      end
    end
  end

end