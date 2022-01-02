class CreateChallenges < ActiveRecord::Migration[6.1]
  def change
    create_table :challenges do |t|
      t.string :title, null: false, index: { unique: true }
      t.jsonb :dataset, null: false, default: {}
      t.integer :xp, null: false
      t.boolean :accomplished, default: false
      t.boolean :active, default: true

      t.string :type, null: false
      t.belongs_to :battle_pass, foreign_key: true
      t.timestamps
    end

    add_index :challenges, [:battle_pass_id, :title, :active], unique: true
  end
end
