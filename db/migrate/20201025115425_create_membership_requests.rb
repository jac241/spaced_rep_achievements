class CreateMembershipRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :membership_requests do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end

    add_index :membership_requests, [:group_id, :user_id], unique: true
  end
end
