# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_28_083523) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_bookmarks_on_course_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "instructor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: true, null: false
    t.datetime "ends_at"
    t.boolean "is_archived", default: false, null: false
    t.index ["instructor_id"], name: "index_courses_on_instructor_id"
    t.index ["is_archived"], name: "index_courses_on_is_archived"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "enrolled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email", null: false
    t.bigint "course_id", null: false
    t.bigint "invited_by_id", null: false
    t.string "token", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_invitations_on_course_id"
    t.index ["invited_by_id"], name: "index_invitations_on_invited_by_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "content_type", default: "text"
    t.bigint "topic_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.bigint "student_response_id"
    t.datetime "ends_at"
    t.boolean "is_open", default: true
    t.string "attachment"
    t.index ["student_response_id"], name: "index_lessons_on_student_response_id"
    t.index ["topic_id"], name: "index_lessons_on_topic_id"
  end

  create_table "marks", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.bigint "user_id", null: false
    t.integer "value"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "response_id"
    t.index ["lesson_id"], name: "index_marks_on_lesson_id"
    t.index ["response_id"], name: "index_marks_on_response_id"
    t.index ["user_id"], name: "index_marks_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "noticed_events", force: :cascade do |t|
    t.string "type"
    t.string "record_type"
    t.bigint "record_id"
    t.jsonb "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.string "type"
    t.bigint "event_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "title"
    t.boolean "is_correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "lesson_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_questions_on_lesson_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "mark_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment"
    t.string "responseable_type"
    t.bigint "responseable_id"
    t.index ["mark_id"], name: "index_responses_on_mark_id"
    t.index ["responseable_type", "responseable_id"], name: "index_responses_on_responseable"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.bigint "course_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_topics_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role", default: "student", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "uid"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookmarks", "courses"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "courses", "users", column: "instructor_id"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
  add_foreign_key "invitations", "courses"
  add_foreign_key "invitations", "users", column: "invited_by_id"
  add_foreign_key "lessons", "responses", column: "student_response_id", on_delete: :nullify
  add_foreign_key "lessons", "topics"
  add_foreign_key "marks", "lessons"
  add_foreign_key "marks", "responses", on_delete: :cascade
  add_foreign_key "marks", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "lessons"
  add_foreign_key "responses", "marks"
  add_foreign_key "responses", "users"
  add_foreign_key "topics", "courses"
end
