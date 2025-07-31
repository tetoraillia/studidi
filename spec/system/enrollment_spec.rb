require 'rails_helper'

RSpec.describe 'Course enrollment', type: :system do
  let(:course_owner) { create(:user) }
  let(:student) { create(:user) }
  let!(:course) { create(:course, instructor: course_owner) }

  before do
    driven_by(:rack_test)
    system_login_as(student)
  end

  it 'allows a user to enroll in a course' do
    visit course_path(course)

    expect(page).to have_content(course.title)

    click_button 'Enroll'

    expect(page).to have_content('Successfully enrolled in the course')
    expect(student.enrolled_in?(course)).to be_truthy
  end

  it 'allows a user to unenroll from a course' do
    create(:enrollment, course: course, user: student)
    visit courses_path

    expect(page).to have_content('Enrolled')

    click_button 'Leave'

    expect(page).to have_content('You have left the course.')
    expect(student.enrolled_in?(course)).to be_falsey
  end
end
