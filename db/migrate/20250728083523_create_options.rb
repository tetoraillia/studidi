class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :title
      t.boolean :is_correct, default: false

      t.timestamps
    end
  end
end
