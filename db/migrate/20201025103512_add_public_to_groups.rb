class AddPublicToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :public, :boolean, default: false
  end
end
