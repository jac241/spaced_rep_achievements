class IndexSyncsOnClientUuidAndCreatedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :syncs, :created_at
    add_index :syncs, :client_uuid
  end
end
