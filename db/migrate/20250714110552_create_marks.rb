class CreateMarks < ActiveRecord::Migration[8.0]
  def change
    create_table :marks do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value
      t.string :comment

      t.timestamps
    end
  end
end
