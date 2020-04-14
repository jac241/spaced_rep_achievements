class AddClientUuidAndIndexToMedals < ActiveRecord::Migration[6.0]
  def change
    # need to do unique index on client_uuid
    add_column :medals, :client_uuid, :uuid, null: false

    add_index :medals, [:client_uuid, :client_db_id], unique: true
  end
end
