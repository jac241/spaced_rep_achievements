class AddUserIdToSyncs < ActiveRecord::Migration[6.0]
  def change
    add_reference :syncs, :user, foreign_key: true
  end
end
