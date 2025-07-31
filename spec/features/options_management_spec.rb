require 'rails_helper'

RSpec.feature "Options Management", type: :feature do
  include Devise::Test::IntegrationHelpers
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:topic) { create(:topic, course: course) }
  let(:lesson) { create(:lesson, topic: topic) }

  before do
    sign_in user
  end

  scenario "User can see the add option button" do
    visit new_course_topic_lesson_question_path(course, topic, lesson)
    expect(page).to have_button("+ Add Option")
  end

  scenario "Add option button is present and clickable" do
    visit new_course_topic_lesson_question_path(course, topic, lesson)

    expect(page).to have_button("+ Add Option")
    expect { click_button "+ Add Option" }.not_to raise_error
  end
end
