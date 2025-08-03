module SystemHelpers
  def system_login_as(user)
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'commit'
    end
  end
end
