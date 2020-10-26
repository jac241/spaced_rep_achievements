class AddTagAndColorToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :tag, :string
    add_column :groups, :color, :string, default: "#0275d8", null: false
  end
end
