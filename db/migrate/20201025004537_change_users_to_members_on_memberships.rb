class ChangeUsersToMembersOnMemberships < ActiveRecord::Migration[6.0]
  def change
    rename_column :memberships, :user_id, :member_id
  end
end
