class CreateCourseModules < ActiveRecord::Migration[8.0]
  def change
    create_table :course_modules do |t|
      t.string :title
      t.references :course, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
