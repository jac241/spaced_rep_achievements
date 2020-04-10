class AddTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :token, :string

    User.all.each(&:regenerate_token)

    change_column :users, :token, :string, null: false
  end
end
