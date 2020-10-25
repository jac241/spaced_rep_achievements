class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :description, null: false, default: ""

      t.timestamps
    end
  end
end
