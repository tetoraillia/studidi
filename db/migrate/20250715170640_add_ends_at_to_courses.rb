class AddEndsAtToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :ends_at, :datetime
  end
end
