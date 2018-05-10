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

  scenario "can sign in user with Twitter account" do
    visit new_user_session_path
    expect(page).to have_content("Sign in with Twitter")
    p mock_auth_hash
    click_on 'Sign in with Twitter'
    expect(page).to have_content("Successfully authenticated from Twitter account.")
    expect(page).to have_content("Log out")
  end

  scenario "can handle authentication error with Twitter" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit new_user_session_path
    expect(page).to have_content("Sign in with Twitter")
    click_on "Sign in with Twitter"
    expect(page).to have_content('Could not authenticate you from Twitter because "Invalid credentials"')
  end

  scenario "can sign in user with Vkontakte account" do
    visit new_user_session_path
    expect(page).to have_content("Sign in with Vkontakte")
    p mock_auth_hash
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content("Successfully authenticated from Vkontakte account.")
    expect(page).to have_content("Log out")
  end

  scenario "can handle authentication error with Vkontakte" do
    OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
    visit new_user_session_path
    expect(page).to have_content("Sign in with Vkontakte")
    click_on "Sign in with Vkontakte"
    expect(page).to have_content('Could not authenticate you from Vkontakte because "Invalid credentials"')
  end
end
