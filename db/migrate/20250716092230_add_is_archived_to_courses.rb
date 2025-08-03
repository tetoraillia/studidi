class AddIsArchivedToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :is_archived, :boolean, default: false, null: false
    add_index :courses, :is_archived
  end
end
