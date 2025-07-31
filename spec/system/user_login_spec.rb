require 'rails_helper'

RSpec.describe 'User Login', type: :feature do
  before :each do
    User.create(email: 'example@example.com', first_name: 'Example', last_name: 'Example', password: 'password', password_confirmation: 'password')
  end

  it "signs me in" do
    visit new_user_session_path

    fill_in 'Email', with: 'example@example.com'
    fill_in 'Password', with: 'password'
    click_button 'commit'

    expect(page).to have_content 'Signed in successfully'
  end

  it "allows a new user to sign up" do
    visit new_user_registration_path

    fill_in 'First name', with: 'Example'
    fill_in 'Last name', with: 'User'
    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'securepassword'
    fill_in 'Password confirmation', with: 'securepassword'

    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_current_path(root_path)
  end
end
