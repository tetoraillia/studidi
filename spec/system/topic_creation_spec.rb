require 'rails_helper'

RSpec.describe 'Topic creation', type: :system do
  let(:user) { create(:user, :teacher) }
  let!(:course) { create(:course, instructor: user) }
  let!(:topic) { create(:topic, course: course) }

  before do
    driven_by(:rack_test)
    system_login_as(user)
  end

  it 'allows a user to create a new topic' do
    visit new_course_topic_path(course)

    fill_in 'Title', with: 'New Topic Title'
    click_button 'commit'

    expect(page).to have_content('Topic was successfully created.')
    expect(page).to have_content('New Topic Title')
  end

  it 'allows a user to delete a topic' do
    visit course_topics_path(course)

    click_button 'Delete'

    expect(page).to have_content('Topic was successfully destroyed.')
    expect(page).not_to have_content(topic.title)
  end

  it 'allows a user to create a lesson within a topic' do
    visit course_topic_path(course, topic)

    click_link 'New Lesson'

    choose 'Text Lesson'
    click_button 'Continue'

    fill_in 'Title', with: 'New Lesson Title'
    fill_in 'Content', with: 'This is the content of the new lesson.'
    click_button 'Create Lesson'

    expect(page).to have_content('Lesson was successfully created.')
    expect(page).to have_content('New Lesson Title')
  end
end
