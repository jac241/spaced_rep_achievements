class CreateSyncs < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    create_table :syncs, id: :uuid do |t|
      t.uuid :client_uuid, null: false

      t.timestamps
    end
  end
end
