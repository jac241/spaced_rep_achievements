class CreateMedals < ActiveRecord::Migration[6.0]
  def change
    create_table :medals, id: :uuid do |t|
      t.references :sync, foreign_key: true, type: :uuid
      t.integer :client_db_id, null: false
      t.string :client_medal_id, null: false
      t.integer :client_deck_id, null: false, limit: 8 # big int
      t.datetime :client_earned_at, null: false
    end
  end
end
