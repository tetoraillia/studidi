class AddUidAndProviderToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end
end
