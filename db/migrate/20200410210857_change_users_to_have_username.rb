class ChangeUsersToHaveUsername < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :first_name, :username
    remove_column :users, :last_name

    change_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
  end
end
