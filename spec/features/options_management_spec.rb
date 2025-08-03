require 'rails_helper'

RSpec.feature "Options Management", type: :feature do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: user) }
  let(:topic) { create(:topic, course: course) }
  let(:lesson) { create(:lesson, topic: topic) }

  before do
    sign_in user
  end

  scenario "Teacher can see the add option button" do
    visit new_course_topic_lesson_question_path(course, topic, lesson)
    expect(page).to have_content("Options:")
    expect(page).to have_css("#options")
    expect(page).to have_button("+ Add Option")
  end

  scenario "Add option button is present with initial option fields" do
    visit new_course_topic_lesson_question_path(course, topic, lesson)
    expect(page).to have_css("#options .option-field", count: 2)
    expect(page).to have_button("+ Add Option")
  end
end
