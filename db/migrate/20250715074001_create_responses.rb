class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :mark, null: true, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
