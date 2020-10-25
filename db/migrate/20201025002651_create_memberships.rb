class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.boolean :admin, default: false
    end

    add_reference :memberships, :group, foreign_key: true
    add_reference :memberships, :user, foreign_key: true
  end
end
