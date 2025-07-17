class AddAttachmentToResponses < ActiveRecord::Migration[8.0]
  def change
    add_column :responses, :attachment, :string
  end
end
