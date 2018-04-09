require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answer for question', js: true do
    within '.new_answer' do
      fill_in 'Body', with: 'text text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add answer'
    end

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds two files when answer for question', js: true do
    within '.new_answer' do
      fill_in 'Body', with: 'text text text'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add attachment'

      within find(:xpath, "(//div[@class='nested-fields'])[2]") do
        attach_file "File", "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Add answer'
    end

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end