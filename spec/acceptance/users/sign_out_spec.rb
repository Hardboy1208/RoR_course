require 'rails_helper'

feature 'User sign out', %q{
  As an user
  I want to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try sign out' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
