require_relative '../acceptance_helper'

feature 'User sign up', %q{
  As an user
  I want to registration in system
} do

  given(:user) { build(:user) }

  scenario 'Registeration new user' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
