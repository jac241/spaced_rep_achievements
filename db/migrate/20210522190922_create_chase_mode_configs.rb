class CreateChaseModeConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :chase_mode_configs do |t|
      t.boolean :only_show_active_users, default: false, null: false
      t.references :user, foreign_key: true, index: { unique: true }
    end

    User.find_each(&:create_chase_mode_config!)
  end
end
