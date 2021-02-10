class AddClientDbUuidToAchievements < ActiveRecord::Migration[6.0]
  def change
    add_column :achievements, :client_db_uuid, :uuid, default: "gen_random_uuid()", null: false

    add_index :achievements, :client_db_uuid, unique: true
  end
end
