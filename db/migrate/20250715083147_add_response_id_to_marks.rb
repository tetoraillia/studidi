class AddResponseIdToMarks < ActiveRecord::Migration[8.0]
  def change
    add_reference :marks, :response, foreign_key: true
  end
end
