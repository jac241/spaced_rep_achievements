class AddTimestampsToAchievements < ActiveRecord::Migration[6.0]
  def change
    add_column :achievements, :created_at, :datetime, null: false
    add_column :achievements, :updated_at, :datetime, null: false

    add_column :medals, :created_at, :datetime
    add_column :medals, :updated_at, :datetime

    Medal.all.update(created_at: Time.now, updated_at: Time.now)

    change_column :medals, :created_at, :datetime, null: false
    change_column :medals, :updated_at, :datetime, null: false
  end
end
