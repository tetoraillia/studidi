class ChangeStudentResponseFkToNullify < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :lessons, column: :student_response_id
    add_foreign_key :lessons, :responses, column: :student_response_id, on_delete: :nullify
  end
end
