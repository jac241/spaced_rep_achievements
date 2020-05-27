class PopulateUidWithEmail < ActiveRecord::Migration[6.0]
  def up
    User.all.each do |u|
      u.uid = u.email
      u.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
