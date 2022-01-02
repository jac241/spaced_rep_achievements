class CreateBattlePasses < ActiveRecord::Migration[6.1]
  def change
    create_table :battle_passes do |t|
      t.integer :xp, default: 0, null: false

      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
