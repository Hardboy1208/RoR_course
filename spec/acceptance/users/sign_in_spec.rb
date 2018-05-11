require_relative '../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password. Log in Email Password Remember me Sign up Forgot your password?'
    expect(current_path).to eq new_user_session_path
  end

  shared_examples "Sign in with" do |name|
    scenario "can sign in user with #{name} account" do
      visit new_user_session_path
      expect(page).to have_content("Sign in with #{name}")
      mock_auth_hash
      click_on "Sign in with #{name}"
      expect(page).to have_content("Successfully authenticated from #{name} account.")
      expect(page).to have_content("Log out")
    end

    scenario "can handle authentication error with #{name}" do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_content("Sign in with #{name}")
      click_on "Sign in with #{name}"
      expect(page).to have_content("Could not authenticate you from #{name} because \"Invalid credentials\"")
    end
  end

  include_examples "Sign in with", "Twitter"
  include_examples "Sign in with", "Vkontakte"
end
