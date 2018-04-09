require_relative '../acceptance_helper'

feature 'Delete file answer', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Author delete file in answer', js: true do
    sign_in(author)
    visit question_path(question)

    within '.new_answer' do
      fill_in 'Body', with: 'text text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add answer'
    end

    within '.answers' do
      click_on 'delete attachment'
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'Non Author delete file in answer', js: true do
    sign_in(author)
    visit question_path(question)

    within '.new_answer' do
      fill_in 'Body', with: 'text text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add answer'
    end

    click_on 'Log out'

    sign_in(non_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'delete attachment'
    end
  end
end
