class AddUserResponseReferencesToLessons < ActiveRecord::Migration[8.0]
  def change
    add_reference :lessons, :student_response, foreign_key: { to_table: :responses }, index: true
  end
end
