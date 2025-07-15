class DropResponsesTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :responces
  end

  def down
    create_table :responces do |t|
      t.bigint :lesson_id, null: false
      t.bigint :user_id, null: false
      t.bigint :mark_id, null: false
      t.text :content
      t.timestamps
    end

    add_index :responces, :lesson_id
    add_index :responces, :mark_id
    add_index :responces, :user_id

    add_foreign_key :responces, :lessons
    add_foreign_key :responces, :marks
    add_foreign_key :responces, :users
  end
end
