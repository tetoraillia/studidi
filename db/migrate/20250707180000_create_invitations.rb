class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.references :course, null: false, foreign_key: true
      t.references :invited_by, null: false, foreign_key: { to_table: :users }
      t.string :token, null: false
      t.string :status, default: "pending"
      t.timestamps
    end
    add_index :invitations, :token, unique: true
  end
end
