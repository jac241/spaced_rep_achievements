class AddTagTextColorToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :tag_text_color, :integer, default: 0, null: false
  end
end
