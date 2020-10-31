class AddMessageToMembershipRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_requests, :message, :string, null: false, default: ""
  end
end
