class RemoveOldRespondableFromResponses < ActiveRecord::Migration[8.0]
  def change
    if index_exists?(:responses, [:respondable_type, :respondable_id], name: :index_responses_on_respondable_type_and_respondable_id)
      remove_index :responses, name: :index_responses_on_respondable_type_and_respondable_id
    end
    remove_column :responses, :respondable_type, :string if column_exists?(:responses, :respondable_type)
    remove_column :responses, :respondable_id, :bigint if column_exists?(:responses, :respondable_id)
  end
end
