class AddEndsAtToLessons < ActiveRecord::Migration[8.0]
  def change
    add_column :lessons, :ends_at, :datetime
    add_column :lessons, :is_open, :boolean, default: true
  end
end
