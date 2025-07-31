require 'rails_helper'

RSpec.describe 'Course management', type: :system do
  let(:user) { create(:user, :teacher) }

  before do
    driven_by(:rack_test)
    system_login_as(user)
  end

  it 'allows a user to create a new course' do
    visit new_course_path

    fill_in 'Title', with: 'New Capybara Course'
    fill_in 'Description', with: 'A brand new course created with Capybara.'
    click_button 'Create Course'

    expect(page).to have_content('Course was successfully created.')
    expect(page).to have_content('New Capybara Course')
  end

  it 'allows a user to delete a course' do
    course = create(:course, instructor: user)
    visit courses_path

    expect(page).to have_content(course.title)

    visit course_path(course)

    click_button 'Delete Course'

    expect(page).to have_content('Course was successfully destroyed.')
    expect(page).not_to have_content(course.title)
  end
end
