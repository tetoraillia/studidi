require 'rails_helper'

RSpec.describe 'Main pages', type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    system_login_as(user)
  end

  it 'successfully loads the home page' do
    visit root_path
    expect(page).to have_content('Courses')
  end

  it 'successfully loads the notifications page' do
    visit notifications_path
    expect(page).to have_content('Notifications')
  end

  it 'successfully loads the bookmarks page' do
    visit bookmarks_path
    expect(page).to have_content('Bookmarks')
  end
end
