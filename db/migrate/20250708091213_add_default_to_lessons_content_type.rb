class AddDefaultToLessonsContentType < ActiveRecord::Migration[8.0]
  def change
    change_column_default :lessons, :content_type, from: nil, to: "text"
  end
end
