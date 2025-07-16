class FixForeignKeyConstraints < ActiveRecord::Migration[8.0]
  def change
    # Remove the existing foreign key constraint
    remove_foreign_key :responses, :lessons

    # Add a new foreign key with CASCADE delete
    add_foreign_key :responses, :lessons, on_delete: :cascade

    # Also update the marks foreign key to be consistent
    remove_foreign_key :marks, :responses if foreign_key_exists?(:marks, :responses)
    add_foreign_key :marks, :responses, on_delete: :cascade
  end
end
