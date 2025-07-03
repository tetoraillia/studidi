class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.string :title
      t.text :content
      t.string :content_type
      t.references :course_module, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
